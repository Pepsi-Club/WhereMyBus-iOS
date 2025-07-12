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
        flow: FlowState
    ) -> SearchCoordinator
    
    func makeBusStopCoordinator(
        parent: Coordinator,
        navigationController: UINavigationController,
        busStopId: String,
        flow: FlowState
    ) -> BusStopCoordinator

    func makeAddRegularAlarmCoordinator(
        parent: Coordinator,
        navigationController: UINavigationController,
        flow: FlowState
    ) -> AddRegularAlarmCoordinator
}
