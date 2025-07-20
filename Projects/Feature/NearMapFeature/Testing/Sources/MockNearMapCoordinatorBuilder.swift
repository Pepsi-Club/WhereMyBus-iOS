//
//  MockNearMapCoordinatorBuilder.swift
//  NearMapFeature
//
//  Created by gnksbm on 7/19/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import UIKit

public final class MockNearMapCoordinatorBuilder: NearMapCoordinatorBuilder {
    public init() { }
    
    public func build(
        parent: Coordinator,
        navigationController: UINavigationController,
        flow: FlowState,
        busStopId: String?
    ) -> NearMapCoordinator {
        DefaultNearMapCoordinator(
            parent: parent,
            navigationController: navigationController,
            coordinatorProvider: MockCoordinatorProvider(),
            flow: flow,
            busStopId: busStopId
        )
    }
}

