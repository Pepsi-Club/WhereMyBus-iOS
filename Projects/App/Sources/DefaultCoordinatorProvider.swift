//
//  DefaultCoordinatorProvider.swift
//  App
//
//  Created by gnksbm on 1/25/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import FeatureDependency
import SearchFeature
import AlarmFeature
import BusStopFeature
import NearMapFeature
import Domain

final class DefaultCoordinatorProvider: CoordinatorProvider {
    
    func makeBusStopCoordinator(
        navigationController: UINavigationController,
        busStopId: String
    ) -> BusStopCoordinator {
        DefaultBusStopCoordinator(
            parent: nil,
            navigationController: navigationController,
            busStopId: busStopId,
            coordinatorProvider: self
        )
    }
    
    func makeSearchCoordinator(
        navigationController: UINavigationController
    ) -> SearchCoordinator {
        DefaultSearchCoordinator(
            parent: nil,
            navigationController: navigationController,
            coordinatorProvider: self
        )
    }
    
    func makeAddRegularAlarmCoordinator(
        navigationController: UINavigationController
    ) -> AddRegularAlarmCoordinator {
        DefaultAddRegularAlarmCoordinator(
            navigationController: navigationController,
            coordinatorProvider: self
        )
    }
    
    func makeBusStopMapCoordinator(
        navigationController: UINavigationController,
        busStopId: String
    ) -> NearMapCoordinator {
        DefaultNearMapCoordinator(
            parent: nil,
            navigationController: navigationController
        )
    }
}
