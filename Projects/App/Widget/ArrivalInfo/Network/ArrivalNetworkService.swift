//
//  ArrivalNetworkService.swift
//  Widget
//
//  Created by 유하은 on 5/7/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain
import NetworkService

import RxSwift

@available(iOS 17.0, *)
final class ArrivalNetworkService {
    private let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func fetchArrivalList(
        busStopId: String
    ) -> Observable<BusStopArrivalInfoResponse> {
        networkService.request(
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
