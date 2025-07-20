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
    public var coordinatorType: CoordinatorType = .addAlarm
    
    private var vcForFinishFlow: UIViewController?
    private weak var viewModel: AddRegularAlarmViewModel?
    
    public init(
        parent: Coordinator,
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider,
        flow: FlowState
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
        self.flow = flow
    }
    
    public func start() {
        let addRegularAlarmViewController = AddRegularAlarmViewController(viewModel: .init(coordinator: self))
        vcForFinishFlow = addRegularAlarmViewController
        navigationController.pushViewController(
            addRegularAlarmViewController,
            animated: true
        )
    }
}

extension DefaultAddRegularAlarmCoordinator: AddRegularAlarmCoordinator {
    public func start(with: RegularAlarmResponse) {
        let viewModel = AddRegularAlarmViewModel(alarmToEdit: with, coordinator: self)
        let addRegularAlarmViewController = AddRegularAlarmViewController(viewModel: viewModel)
        self.viewModel = viewModel
        vcForFinishFlow = addRegularAlarmViewController
        navigationController.pushViewController(
            addRegularAlarmViewController,
            animated: true
        )
    }
    
    public func startSearchFlow() {
        let searchCoordinator = coordinatorProvider.makeSearchCoordinator(
            parent: self,
            navigationController: navigationController,
            flow: .fromAlarm,
            busStopCoordinatorDelegate: viewModel
        )
        childs.append(searchCoordinator)
        searchCoordinator.start()
    }
    
    public func removeChildViewController() {
        guard let vcForFinishFlow else { return }
        navigationController.popToViewController(
            vcForFinishFlow,
            animated: true
        )
    }
}
