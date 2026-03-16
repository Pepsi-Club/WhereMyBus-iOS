//
//  DefaultBusStopArrivalInfoRepository.swift
//  Data
//
//  Created by gnksbm on 1/30/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain
import Core
import NetworkService

import RxSwift
import FirebaseInterface

public final class DefaultBusStopArrivalInfoRepository: NSObject, BusStopArrivalInfoRepository {
    @Injected private var networkService: NetworkService
    @Injected private var logger: FirebaseLogger
    
    public func fetchArrivalList(busStopId: String) async throws -> BusStopArrivalInfoResponse {
        try await networkService.request(endPoint: BusStopArrivalInfoEndPoint(arsId: busStopId))
            .decode(type: BusStopArrivalInfoDTO.self)
            ._toDomain
    }
    
    public func fetchArrivalList(busStopId: String) -> Observable<BusStopArrivalInfoResponse> {
        logger.log(name: "fetchArrivalEvent")
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
