//
//  MockAddRegularAlarmCoordinatorBuilder.swift
//  AlarmFeatureTesting
//
//  Created by gnksbm on 7/19/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import UIKit

public final class MockAddRegularAlarmCoordinatorBuilder: AddRegularAlarmCoordinatorBuilder {
    public init() { }
    public func build(
        parent: Coordinator,
        navigationController: UINavigationController,
        flow: FlowState
    ) -> AddRegularAlarmCoordinator {
        DefaultAddRegularAlarmCoordinator(
            parent: parent,
            navigationController: navigationController,
            coordinatorProvider: MockCoordinatorProvider(),
            flow: flow
        )
    }
}
