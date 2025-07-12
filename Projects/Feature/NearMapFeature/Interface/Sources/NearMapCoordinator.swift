//
//  NearMapCoordinator.swift
//  NearMapFeature
//
//  Created by gnksbm on 7/12/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import UIKit

@_exported import FeatureDependency

public protocol NearMapCoordinator: Coordinator {
    func startBusStopFlow(busStopId: String)
}

public protocol NearMapCoordinatorBuilder {
    func build(
        parent: Coordinator,
        navigationController: UINavigationController,
        flow: FlowState,
        busStopId: String?
    ) -> NearMapCoordinator
}
