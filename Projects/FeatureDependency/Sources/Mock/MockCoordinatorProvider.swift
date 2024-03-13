//
//  MockCoordinatorProvider.swift
//  FeatureDependency
//
//  Created by gnksbm on 3/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Domain

#if DEBUG
public final class MockCoordinatorProvider: CoordinatorProvider {
    public init() { }
    
    public func makeSearchCoordinator(
        navigationController: UINavigationController,
        flow: FlowState
    ) -> SearchCoordinator {
        MockCoordinator(
            testMessage: "Search",
            navigationController: navigationController
        )
    }
    
    public func makeBusStopCoordinator(
        navigationController: UINavigationController,
        busStopId: String,
        flow: FlowState
    ) -> BusStopCoordinator {
        MockCoordinator(
            testMessage: "BusStop", 
            navigationController: navigationController
        )
    }
    
    public func makeAddRegularAlarmCoordinator(
        navigationController: UINavigationController,
        flow: FlowState
    ) -> AddRegularAlarmCoordinator {
        MockCoordinator(
            testMessage: "AddRegularAlarm",
            navigationController: navigationController
        )
    }
    
    public func makeBusStopMapCoordinator(
        navigationController: UINavigationController,
        busStopId: String,
        flow: FlowState
    ) -> NearMapCoordinator {
        MockCoordinator(
            testMessage: "NearMap",
            navigationController: navigationController
        )
    }
}
#endif
