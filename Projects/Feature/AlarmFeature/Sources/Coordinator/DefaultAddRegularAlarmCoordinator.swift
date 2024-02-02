//
//  DefaultAddRegularAlarmCoordinator.swift
//  AlarmFeature
//
//  Created by gnksbm on 2/2/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import FeatureDependency

final class DefaultAddRegularAlarmCoordinator {
    var parent: Coordinator?
    var childs: [Coordinator] = []
    var navigationController: UINavigationController
    let coordinatorProvider: CoordinatorProvider
    
    init(
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
    ) {
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
    }
    
    func start() {
        let addRegularAlarmViewController = AddRegularAlarmViewController(
            viewModel: .init(coordinator: self)
        )
        navigationController.pushViewController(
            addRegularAlarmViewController,
            animated: true
        )
    }
    
    func finish() {
        
    }
}

extension DefaultAddRegularAlarmCoordinator: AddRegularAlarmCoordinator {
    // TODO: Alarm 모델링 후 인자 타입 수정
    func start(with: String) {
        let addRegularAlarmViewController = AddRegularAlarmViewController(
            viewModel: .init(alarmToEdit: with, coordinator: self)
        )
        navigationController.pushViewController(
            addRegularAlarmViewController,
            animated: true
        )
    }
    
    func startSearchFlow() {
        let searchCoordinator = coordinatorProvider.makeSearchCoordinator(
            navigationController: navigationController
        )
        childs.append(searchCoordinator)
        searchCoordinator.start()
    }
    
    func complete() {
        
    }
}
