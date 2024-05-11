//
//  BusStopUseCase.swift
//  Domain
//
//  Created by Jisoo HAM on 2/5/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol BusStopUseCase {
    var busStopSection
    : PublishSubject<BusStopArrivalInfoResponse> { get }
    
    func fetchBusArrivals(request: ArrivalInfoRequest)
    
    /// BusArrivals를 Fetch 받을 때 쓰로틀 제약이 있는 함수
    /// - parameter request: busStopId를 가지고 있는 구조체
    /// - returns: 쓰로틀의 상태.
    ///     .running: 쓰로틀 제약이 걸려있는 상태
    ///     .completed: 쓰로틀 제약이 풀려있는 상태
    func throttlefetchBusArrivals(
            request: ArrivalInfoRequest
        ) -> FetchThrottleStatus
    
    func handleFavorites(
        isFavorites: Bool,
        favorites: FavoritesBusResponse
    ) throws
    
    func update(
        busStopInfo: BusStopArrivalInfoResponse,
        busInfo: BusArrivalInfoResponse
    )
}
