//
//  ArrivalInfoUseCase.swift
//  App
//
//  Created by gnksbm on 4/8/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain
import NetworkService
import CoreDataService

import RxSwift


@available(iOS 17.0, *)
final class ArrivalInfoUseCase {
    private let coreDataService: CoreDataService
    private let networkService: NetworkService
    
    public init(networkService: NetworkService, coreDataService: CoreDataService) {
        self.networkService = networkService
        self.coreDataService = coreDataService
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
    
    func loadBusStopArrivalInfo() {
        coreDataService.fetch(
            type: FavoritesBusResponse.self
        )
    }
}
