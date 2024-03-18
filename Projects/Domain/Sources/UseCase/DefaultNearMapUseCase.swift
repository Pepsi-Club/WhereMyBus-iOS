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
    public let nearByBusStop = PublishSubject<BusStopInfoResponse>()
    private let disposeBag = DisposeBag()
	
    public init(
        stationListRepository: StationListRepository,
        locationService: LocationService
    ) {
        self.stationListRepository = stationListRepository
		self.locationService = locationService
    }
  
    // MARK: - 함수 호출될 때 마다
    public func updateNearByBusStop() {
        
        locationService.authState
            .withLatestFrom(
                stationListRepository.stationList
            ) { authState, stationList in
                (authState, stationList)
            }
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, tuple in
                    let (authState, stationList) = tuple
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
                            useCase.nearByBusStop.onNext(result)
                        case .denied:
                            let desciption = "주변 정류장을 확인하려면 위치 정보를 동의해주세요."
                            let result = BusStopInfoResponse(
                                busStopName: desciption,
                                busStopId: "",
                                direction: "",
                                longitude: "",
                                latitude: ""
                            )
                            useCase.nearByBusStop.onNext(result)
                        case .authorizedAlways, .authorizedWhenInUse:
                            useCase.locationService.requestLocationOnce()
                        @unknown default:
                            break
                    }
                }
            )
            .disposed(by: disposeBag)
        
        // TODO: - 함수 실행마다 중복으로 subscribe되고 있음 fix 필요
        locationService.currentLocation
            .subscribe(
                with: self,
                onNext: { usecase, _ in
                    do {
                        let result =
                        try usecase.stationListRepository
                            .getBusStopNearCurrentLocation()
                        
                        usecase.nearByBusStop
                            .onNext(result.nearBusStop)
                        
                    } catch {
                        print("가까운 정류장을 구할 수 없습니다.")
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
            guard let selectedBusStop = responses.first(where: { response in
                response.busStopId == busStopId
            })
            else { return }
            nearByBusStop.onNext(selectedBusStop)
        } catch {
            print(error.localizedDescription)
        }
    }
}
