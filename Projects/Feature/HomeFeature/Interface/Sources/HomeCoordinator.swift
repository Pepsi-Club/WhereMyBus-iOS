//
//  HomeCoordinator.swift
//  HomeFeatureInterface
//
//  Created by gnksbm on 7/19/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import UIKit

import FeatureDependency

public protocol HomeCoordinator: Coordinator {
    func startSearchFlow()
    func startBusStopFlow(stationId: String)
}

public protocol HomeCoordinatorBuilder {
    func build(
        parent: Coordinator,
        navigationController: UINavigationController
    ) -> HomeCoordinator
}
