//
//  FavoritesRepository.swift
//  Domain
//
//  Created by gnksbm on 1/30/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol FavoritesRepository {
    var favorites: BehaviorSubject<FavoritesResponse> { get }
    
    func addRoute(
        busStopId: String,
        busStopName: String,
        direction: String,
        bus: BusArrivalInfoResponse
    )
    
    func removeRoute(
        busStopId: String,
        bus: BusArrivalInfoResponse
    )
}
