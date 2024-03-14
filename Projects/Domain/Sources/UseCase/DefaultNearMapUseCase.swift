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
    public let stationListRepository: StationListRepository

    public let nearByBusStop = PublishSubject<BusStopInfoResponse>()
    private let disposeBag = DisposeBag()
	
    public init(
        stationListRepository: StationListRepository
    ) {
		self.stationListRepository = stationListRepository
	}
    
    public func getNearByBusStop() {
        do {
            let responses = try stationListRepository.searchResponse.value()
            // TODO: 위치 정보를 이용해 가장 가까운 정류장 찾기로 로직 수정
            let result = responses.first ?? .init(
                busStopName: "주변에 정류장이 없습니다.",
                busStopId: "",
                direction: "",
                longitude: "",
                latitude: ""
            )
            nearByBusStop.onNext(result)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func busStopSelected(busStopId: String) {
        do {
            let responses = try stationListRepository.searchResponse.value()
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
