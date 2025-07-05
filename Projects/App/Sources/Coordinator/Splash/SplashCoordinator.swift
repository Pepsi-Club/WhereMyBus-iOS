//
//  SplashCoordinator.swift
//  App
//
//  Created by gnksbm on 6/30/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import UIKit

import MainFeature
import FeatureDependency

protocol SplashCoordinator: Coordinator {
    func startTabFlow()
    func openURL(_ url: URL)
}

final class SplashCoordinatorImpl: SplashCoordinator {
    var parent: Coordinator?
    var childs: [Coordinator] = []
    var navigationController: UINavigationController
    public var coordinatorType: CoordinatorType = .splash
    private let coordinatorProvider: CoordinatorProvider
    private let viewModelDependency: SplashViewModelDependency
    
    init(
        parent: Coordinator,
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider,
        viewModelDependency: SplashViewModelDependency
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
        self.viewModelDependency = viewModelDependency
    }
    
    func start() {
        let splashViewController = SplashViewController(
            viewModel: SplashViewModel(coordinator: self, dependency: viewModelDependency)
        )
        navigationController.setViewControllers([splashViewController], animated: false)
    }
    
    func startTabFlow() {
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            coordinatorProvider: coordinatorProvider
        )
        childs.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
}
