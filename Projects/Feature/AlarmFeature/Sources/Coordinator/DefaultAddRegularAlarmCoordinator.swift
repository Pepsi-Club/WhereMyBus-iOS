//
//  DefaultAddRegularAlarmCoordinator.swift
//  AlarmFeature
//
//  Created by gnksbm on 2/2/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import FeatureDependency

public final class DefaultAddRegularAlarmCoordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    public let coordinatorProvider: CoordinatorProvider
    
    public init(
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
    ) {
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
    }
    
    public func start() {
        let addRegularAlarmViewController = AddRegularAlarmViewController(
            viewModel: .init(coordinator: self)
        )
        navigationController.pushViewController(
            addRegularAlarmViewController,
            animated: true
        )
    }
    
    public func finish() {
        
    }
}

extension DefaultAddRegularAlarmCoordinator: AddRegularAlarmCoordinator {
    // TODO: Alarm 모델링 후 인자 타입 수정
    public func start(with: String) {
        let addRegularAlarmViewController = AddRegularAlarmViewController(
            viewModel: .init(alarmToEdit: with, coordinator: self)
        )
        navigationController.pushViewController(
            addRegularAlarmViewController,
            animated: true
        )
    }
    
    public func startSearchFlow() {
        let searchCoordinator = coordinatorProvider.makeSearchCoordinator(
            navigationController: navigationController
        )
        childs.append(searchCoordinator)
        searchCoordinator.start()
    }
    
    public func complete() {
        
    }
}
