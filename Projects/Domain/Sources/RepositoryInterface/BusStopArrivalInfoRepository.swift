//
//  BusStopArrivalInfoRepository.swift
//  Domain
//
//  Created by gnksbm on 1/30/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol BusStopArrivalInfoRepository {
    func fetchArrivalList(busStopId: String) async throws -> BusStopArrivalInfoResponse
    
    func fetchArrivalList(
        busStopId: String
    ) -> Observable<BusStopArrivalInfoResponse>
}
