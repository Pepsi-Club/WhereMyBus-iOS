//
//  BusStopCoordinator.swift
//  FeatureDependency
//
//  Created by Jisoo HAM on 2/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Domain

public protocol BusStopCoordinator: Coordinator {
    var delegate: BusStopCoordinatorDelegate? { get }
    
    func busStopMapLocation(busStopId: String)
    func moveToRegualrAlarm()
}

public protocol BusStopCoordinatorDelegate: AnyObject {
    func didSelect(busStopInfo: BusStopArrivalInfoResponse, busInfo: BusArrivalInfoResponse)
}
