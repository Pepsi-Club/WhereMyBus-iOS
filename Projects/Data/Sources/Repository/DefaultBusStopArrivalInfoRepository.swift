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
import Core

import RxSwift
import FirebaseAnalytics

public final class DefaultBusStopArrivalInfoRepository:
    NSObject, BusStopArrivalInfoRepository {
    @Injected private var networkService: NetworkService
    
    private let disposeBag = DisposeBag()
    
    public func fetchArrivalList(busStopId: String) ->
    Observable<BusStopArrivalInfoResponse> {
        Analytics.logEvent("fetchArrivalEvent", parameters: nil)
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
