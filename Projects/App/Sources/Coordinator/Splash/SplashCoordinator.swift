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
import HomeFeatureInterface

protocol SplashCoordinator: Coordinator {
    func startTabFlow()
}

final class SplashCoordinatorImpl: SplashCoordinator {
    var parent: Coordinator?
    var childs: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let coordinatorProvider: CoordinatorProvider
    private let homeCoordinatorBuilder: HomeCoordinatorBuilder
    private let viewModelDependency: SplashViewModelDependency
    
    init(
        parent: Coordinator,
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider,
        homeCoordinatorBuilder: HomeCoordinatorBuilder,
        viewModelDependency: SplashViewModelDependency
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
        self.homeCoordinatorBuilder = homeCoordinatorBuilder
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
            coordinatorProvider: coordinatorProvider,
            homeCoordinatorBuilder: homeCoordinatorBuilder
        )
        childs.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
}
