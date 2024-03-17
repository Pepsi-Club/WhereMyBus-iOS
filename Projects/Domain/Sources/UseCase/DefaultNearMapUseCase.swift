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
                        let noNearByStop = BusStopInfoResponse(
                            busStopName: "주변에 정류장이 없습니다.",
                            busStopId: "",
                            direction: "",
                            longitude: "",
                            latitude: ""
                        )
                        // TODO: 가장 가까운 정류장 찾기로 로직 수정
                        let nearByStop = stationList.first ?? noNearByStop
                        useCase.nearByBusStop.onNext(nearByStop)
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
