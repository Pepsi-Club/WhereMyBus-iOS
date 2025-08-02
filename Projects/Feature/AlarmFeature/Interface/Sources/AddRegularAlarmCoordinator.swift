//
//  AddRegularAlarmCoordinator.swift
//  AlarmFeatureInterface
//
//  Created by gnksbm on 7/19/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import UIKit

public protocol AddRegularAlarmCoordinator: Coordinator {
    func start(with: RegularAlarmResponse)
    func startSearchFlow()
    func removeChildViewController()
}

public protocol AddRegularAlarmCoordinatorBuilder {
    func build(
        parent: Coordinator,
        navigationController: UINavigationController,
        flow: FlowState
    ) -> AddRegularAlarmCoordinator
}
