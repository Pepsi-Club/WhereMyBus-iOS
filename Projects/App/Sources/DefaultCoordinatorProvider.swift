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
        busStopId: String,
        flow: FlowState
    ) -> BusStopCoordinator {
        DefaultBusStopCoordinator(
            parent: nil,
            navigationController: navigationController,
            busStopId: busStopId,
            coordinatorProvider: self,
            flow: flow
        )
    }
    
    func makeSearchCoordinator(
        navigationController: UINavigationController,
        flow: FlowState
    ) -> SearchCoordinator {
        DefaultSearchCoordinator(
            parent: nil,
            navigationController: navigationController,
            coordinatorProvider: self,
            flow: flow
        )
    }
    
    func makeAddRegularAlarmCoordinator(
        navigationController: UINavigationController,
        flow: FlowState
    ) -> AddRegularAlarmCoordinator {
        DefaultAddRegularAlarmCoordinator(
            navigationController: navigationController,
            coordinatorProvider: self,
            flow: .fromAlarm
        )
    }
    
    func makeBusStopMapCoordinator(
        navigationController: UINavigationController,
        busStopId: String,
        flow: FlowState
    ) -> NearMapCoordinator {
        DefaultNearMapCoordinator(
            parent: nil,
            navigationController: navigationController,
            flow: flow
        )
    }
}
