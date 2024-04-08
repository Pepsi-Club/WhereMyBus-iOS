//
//  AppCoordinator.swift
//  YamYamPick
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import UIKit

import FeatureDependency
import MainFeature
import BusStopFeature

final class AppCoordinator: Coordinator {
    var parent: Coordinator?
    var childs: [Coordinator] = []
    var navigationController: UINavigationController
    public var coordinatorType: CoordinatorType = .app
    private let coordinatorProvider = DefaultCoordinatorProvider()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController, 
            coordinatorProvider: coordinatorProvider
        )
        childs.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
    func startBusStopFlow(busStopId: String) {
        let busStopCoordinator = DefaultBusStopCoordinator(
            parent: self,
            navigationController: navigationController,
            busStopId: busStopId,
            coordinatorProvider: coordinatorProvider,
            flow: .fromHome
        )
        childs.append(busStopCoordinator)
        busStopCoordinator.start()
    }
}
