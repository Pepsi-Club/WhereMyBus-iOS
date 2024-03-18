//
//  DefaultNearMapUseCase.swift
//  Domain
//
//  Created by Muker on 2/14/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import CoreLocation
import Foundation

import RxSwift
import RxCocoa

public final class DefaultNearMapUseCase: NearMapUseCase {
    private let stationListRepository: StationListRepository
    private let locationService: LocationService
    
    public let nearBusStopList = PublishSubject<[BusStopInfoResponse]>()
    public let selectedBusStop = PublishSubject<BusStopInfoResponse>()
    public let distanceFromNearByStop = PublishSubject<String>()
    private let disposeBag = DisposeBag()
	
    public init(
        stationListRepository: StationListRepository,
        locationService: LocationService
    ) {
        self.stationListRepository = stationListRepository
		self.locationService = locationService
        bindDistance()
    }
    
    public func updateNearByBusStop() {
        locationService.currentLocation
            .take(1)
            .subscribe(
                with: self,
                onNext: { useCase, location in
                    let (nearBusStop, distance) = useCase.stationListRepository
                        .getNearByStopInfo(startPointLocation: location)
                    useCase.selectedBusStop.onNext(nearBusStop)
                }
            )
            .disposed(by: disposeBag)
        
        locationService.authState
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, authState in
                    switch authState {
                    case .notDetermined:
                        useCase.locationService.authorize()
                    case .restricted:
                        let desciption = "오류가 발생했습니다. 관리자에게 문의해주세요."
                        let result = BusStopInfoResponse(
                            busStopName: desciption,
                            busStopId: "",
                            direction: "",
                            longitude: "",
                            latitude: ""
                        )
                        useCase.selectedBusStop.onNext(result)
                    case .denied:
                        let desciption = "주변 정류장을 확인하려면 위치 정보를 동의해주세요."
                        let result = BusStopInfoResponse(
                            busStopName: desciption,
                            busStopId: "",
                            direction: "",
                            longitude: "",
                            latitude: ""
                        )
                        useCase.selectedBusStop.onNext(result)
                    case .authorizedAlways, .authorizedWhenInUse:
                        useCase.locationService.requestLocationOnce()
                    @unknown default:
                        break
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    public func updateNearBusStopList(
        longitudeRange: ClosedRange<Double>,
        latitudeRange: ClosedRange<Double>
    ) {
        stationListRepository.stationList
            .map { responses in
                responses.filter { response in
                    guard let longitude = Double(response.longitude),
                          let latitude = Double(response.latitude)
                    else { return false }
                    return longitudeRange ~= longitude &&
                    latitudeRange ~= latitude
                }
            }
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, filteredList in
                    useCase.nearBusStopList.onNext(filteredList)
                }
            )
            .disposed(by: disposeBag)
    }
    
    public func busStopSelected(busStopId: String) {
        do {
            let responses = try stationListRepository.stationList.value()
            guard let response = responses.first(
                where: { response in
                    response.busStopId == busStopId
                }
            )
            else { return }
            selectedBusStop.onNext(response)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func bindDistance() {
        selectedBusStop
            .withLatestFrom(
                locationService.currentLocation
            ) { response, location in
                (response, location)
            }
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, tuple in
                    let (response, startPoint) = tuple
                    guard let endPointLatitude = Double(response.latitude),
                          let endPointLongitude = Double(response.longitude)
                    else { return }
                    let distance = Int(
                        CLLocation(
                            latitude: endPointLatitude,
                            longitude: endPointLongitude
                        )
                        .distance(from: startPoint)
                    )
                    let distanceStr: String
                    switch distance {
                    case ..<1000:
                        distanceStr = "\(distance)m"
                    case Int.max:
                        distanceStr = "측정거리 초과"
                    default:
                        distanceStr =  "\(distance / 1000)km"
                    }
                    useCase.distanceFromNearByStop.onNext(distanceStr)
                }
            )
            .disposed(by: disposeBag)
    }
}
