//
//  TabBarCoordinator.swift
//  MainFeature
//
//  Created by gnksbm on 2024/01/08.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import PresentationDependency
import Home
import Alarm
import Settings

public final class TabBarCoordinator: Coordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        setupTabBarController()
    }
    
    private func setupTabBarController() {
        let tabBarController = TabBarViewController()
        
        navigationController.setViewControllers(
            [tabBarController], animated: true
        )
        
        let viewControllers = MainTab.allCases.map {
            makeNavigationController(tabKind: $0)
        }
        
        tabBarController.viewControllers = viewControllers
    }
    
    private func makeNavigationController(
        tabKind: MainTab
    ) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = tabKind.tabItem
        setupChildCoordinators(
            tabKind: tabKind,
            navigationController: navigationController
        )
        return navigationController
    }
    
    private func setupChildCoordinators(
        tabKind: MainTab,
        navigationController: UINavigationController
    ) {
        var coordinator: Coordinator
        switch tabKind {
        case .home:
            coordinator = DefaultHomeCoordinator(
                navigationController: navigationController
            )
        case .settings:
            coordinator = DefaultSettingsCoordinator(
                navigationController: navigationController
            )
        case .alarm:
            coordinator = DefaultAlarmCoordinator(
                navigationController: navigationController
            )
        }
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
