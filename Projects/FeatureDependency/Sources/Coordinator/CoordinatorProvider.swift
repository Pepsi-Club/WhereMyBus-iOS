//
//  CoordinatorProvider.swift
//  FeatureDependency
//
//  Created by gnksbm on 1/26/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Domain

public protocol CoordinatorProvider {
    func makeSearchCoordinator(
        parent: Coordinator,
        navigationController: UINavigationController,
        flow: FlowState,
        busStopCoordinatorDelegate: BusStopCoordinatorDelegate?
    ) -> SearchCoordinator
    
    func makeBusStopCoordinator(
        parent: Coordinator,
        navigationController: UINavigationController,
        busStopId: String,
        flow: FlowState,
        delegate: BusStopCoordinatorDelegate?
    ) -> BusStopCoordinator
}
