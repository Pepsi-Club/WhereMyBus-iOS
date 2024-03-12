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
        arrivalInfoData: ArrivalInfoRequest
    ) -> BusStopCoordinator {
        DefaultBusStopCoordinator(
            parent: nil,
            navigationController: navigationController,
            arrivalInfoData: arrivalInfoData,
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
        navigationController: UINavigationController
    ) -> NearMapCoordinator {
        DefaultNearMapCoordinator(
            parent: nil,
			navigationController: navigationController, 
			coordinatorProvider: self
        )
    }
}
