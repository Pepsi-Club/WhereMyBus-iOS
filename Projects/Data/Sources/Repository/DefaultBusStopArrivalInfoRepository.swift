//
//  DefaultBusStopArrivalInfoRepository.swift
//  Data
//
//  Created by gnksbm on 1/30/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain
import NetworkService

import RxSwift
import FirebaseAnalytics

public final class DefaultBusStopArrivalInfoRepository:
    NSObject, BusStopArrivalInfoRepository {
    private let networkService: NetworkService
    
    private let disposeBag = DisposeBag()
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func fetchArrivalList(busStopId: String) ->
                Observable<BusStopArrivalInfoResponse> {
        // Google Analytics 이벤트 로깅
        Analytics.logEvent("api_use", parameters: [
            "api_name": "fetchArrivalList" as NSObject,
            "bus_stop_id": busStopId as NSObject
        ])
        
        return networkService.request(
            endPoint: BusStopArrivalInfoEndPoint(arsId: busStopId)
        )
        .decode(
            type: BusStopArrivalInfoDTO.self,
            decoder: JSONDecoder()
        )
        .compactMap {
            $0.toDomain
        }
    }
}
