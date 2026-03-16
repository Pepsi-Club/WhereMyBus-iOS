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
    
    @available(*, deprecated, message: "이 메서드는 제거될 예정입니다.")
    func fetchArrivalList(
        busStopId: String
    ) -> Observable<BusStopArrivalInfoResponse>
}
