//
//  DefaultCoordinatorProvider.swift
//  App
//
//  Created by gnksbm on 1/25/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import FeatureDependency
import HomeFeature
import SearchFeature
import AlarmFeature
import BusStopFeature
import NearMapFeature
import NearMapFeatureInterface
import HomeFeatureInterface
import AlarmFeatureInterface
import Domain

final class DefaultCoordinatorProvider: CoordinatorProvider {
    func makeBusStopCoordinator(
        parent: Coordinator,
        navigationController: UINavigationController,
        busStopId: String,
        flow: FlowState,
        delegate: BusStopCoordinatorDelegate?
    ) -> BusStopCoordinator {
        DefaultBusStopCoordinator(
            parent: parent,
            navigationController: navigationController,
            busStopId: busStopId,
            coordinatorProvider: self,
            flow: flow,
            nearMapCoordinatorBuilder: self,
            addRegularAlarmCoordinatorBuilder: self,
            delegate: delegate
        )
    }
    
    func makeSearchCoordinator(
        parent: Coordinator,
        navigationController: UINavigationController,
        flow: FlowState,
        busStopCoordinatorDelegate: BusStopCoordinatorDelegate?
    ) -> SearchCoordinator {
        DefaultSearchCoordinator(
            parent: parent,
            navigationController: navigationController,
            coordinatorProvider: self,
            nearMapCoordinatorBuilder: self,
            busStopCoordinatorDelegate: busStopCoordinatorDelegate,
            flow: flow
        )
    }
    
    func makeAddRegularAlarmCoordinator(
        parent: Coordinator,
        navigationController: UINavigationController,
        flow: FlowState
    ) -> AddRegularAlarmCoordinator {
        DefaultAddRegularAlarmCoordinator(
            parent: parent,
            navigationController: navigationController,
            coordinatorProvider: self,
            flow: .fromAlarm
        )
    }
}

extension DefaultCoordinatorProvider: AddRegularAlarmCoordinatorBuilder {
    func build(parent: any Coordinator, navigationController: UINavigationController, flow: FlowState) -> any AddRegularAlarmCoordinator {
        DefaultAddRegularAlarmCoordinator(
            parent: parent,
            navigationController: navigationController,
            coordinatorProvider: self,
            flow: flow
        )
    }
}

extension DefaultCoordinatorProvider: HomeCoordinatorBuilder {
    func build(parent: any Coordinator, navigationController: UINavigationController) -> HomeCoordinator {
        DefaultHomeCoordinator(
            parent: parent,
            navigationController: navigationController,
            coordinatorProvider: self
        )
    }
}

extension DefaultCoordinatorProvider: NearMapCoordinatorBuilder {
    func build(
        parent: any Coordinator,
        navigationController: UINavigationController,
        flow: FlowState,
        busStopId: String?
    ) -> NearMapCoordinator {
        DefaultNearMapCoordinator(
            parent: parent,
            navigationController: navigationController,
            coordinatorProvider: self,
            flow: flow,
            busStopId: busStopId
        )
    }
}
