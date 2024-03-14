//
//  DefaultAddRegularAlarmCoordinator.swift
//  AlarmFeature
//
//  Created by gnksbm on 2/2/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Domain
import FeatureDependency

public final class DefaultAddRegularAlarmCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    public let coordinatorProvider: CoordinatorProvider
    private let flow: FlowState
    
    public init(
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider,
        flow: FlowState
    ) {
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
        self.flow = flow
    }
    
    public func start() {
        let addRegularAlarmViewController = AddRegularAlarmViewController(
            viewModel: .init(
                coordinator: self
            )
        )
        navigationController.pushViewController(
            addRegularAlarmViewController,
            animated: true
        )
    }
}

extension DefaultAddRegularAlarmCoordinator: AddRegularAlarmCoordinator {
    public func start(with: RegularAlarmResponse) {
        let addRegularAlarmViewController = AddRegularAlarmViewController(
            viewModel: .init(
                alarmToEdit: with,
                coordinator: self
            )
        )
        navigationController.pushViewController(
            addRegularAlarmViewController,
            animated: true
        )
    }
    
    public func startSearchFlow() {
        let searchCoordinator = coordinatorProvider.makeSearchCoordinator(
            navigationController: navigationController,
            flow: .fromAlarm
        )
        childs.append(searchCoordinator)
        searchCoordinator.start()
    }
    
    public func complete() {
        navigationController.popViewController(animated: true)
        finish()
    }
}
