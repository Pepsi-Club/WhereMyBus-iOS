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
        parent: Coordinator,
        navigationController: UINavigationController,
        flow: FlowState,
        busStopCoordinatorDelegate: BusStopCoordinatorDelegate?
    ) -> SearchCoordinator {
        MockCoordinator(
            testMessage: "Search",
            navigationController: navigationController
        )
    }
    
    public func makeBusStopCoordinator(
        parent: Coordinator,
        navigationController: UINavigationController,
        busStopId: String,
        flow: FlowState,
        delegate: BusStopCoordinatorDelegate?
    ) -> BusStopCoordinator {
        MockCoordinator(
            testMessage: "BusStop - busStopId: \(busStopId)",
            navigationController: navigationController
        )
    }
}

#endif
