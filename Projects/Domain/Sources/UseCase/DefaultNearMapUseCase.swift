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

    public let nearByBusStop = PublishSubject<BusStopInfoResponse>()
    private let disposeBag = DisposeBag()
	
    public init(
        stationListRepository: StationListRepository,
        locationService: LocationService
    ) {
        self.stationListRepository = stationListRepository
		self.locationService = locationService
	}
    
    public func getNearByBusStop() {
		
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
                            do {
                                let result =
                                try self.stationListRepository
                                    .getBusStopNearCurrentLocation()
                                useCase.nearByBusStop.onNext(result.nearBusStop)
                            } catch {
                                print("가까운 정류장을 구할 수 없습니다.")
                            }
                    @unknown default:
                        break
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    public func getNearBusStopList() -> [BusStopInfoResponse] {
        do {
            return try stationListRepository.stationList.value()
        } catch {
            return []
        }
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
