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
        navigationController: UINavigationController
    ) -> SearchCoordinator {
        MockCoordinator(
            testMessage: "Search",
            navigationController: navigationController
        )
    }
    
    public func makeBusStopCoordinator(
        navigationController: UINavigationController,
        arrivalInfoData: ArrivalInfoRequest
    ) -> BusStopCoordinator {
        MockCoordinator(
            testMessage: "BusStop", 
            navigationController: navigationController
        )
    }
    
    public func makeAddRegularAlarmCoordinator(
        navigationController: UINavigationController
    ) -> AddRegularAlarmCoordinator {
        MockCoordinator(
            testMessage: "AddRegularAlarm",
            navigationController: navigationController
        )
    }
    
    public func makeBusStopMapCoordinator(
        navigationController: UINavigationController
    ) -> NearMapCoordinator {
        MockCoordinator(
            testMessage: "NearMap",
            navigationController: navigationController
        )
    }
}
#endif