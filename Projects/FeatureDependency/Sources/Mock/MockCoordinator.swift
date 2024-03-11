//
//  MockCoordinator.swift
//  FeatureDependency
//
//  Created by gnksbm on 3/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Domain

#if DEBUG
public final class MockCoordinator: Coordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    
    private let testMessage: String
    public var navigationController: UINavigationController
    
    public init(
        testMessage: String,
        navigationController: UINavigationController
    ) {
        self.testMessage = testMessage
        self.navigationController = navigationController
    }
    
    public func start() {
        let testViewController = UIViewController()
        testViewController.view.backgroundColor = .white
        testViewController.title = testMessage
        navigationController.pushViewController(
            testViewController,
            animated: true
        )
    }
}

extension MockCoordinator: HomeCoordinator {
    public func updateFavoritesState(isEmpty: Bool) {
        
    }
    
    public func startBusStopFlow(stationId: String) {
        let coordinator = MockCoordinator(
            testMessage: "BusStop",
            navigationController: navigationController
        )
        coordinator.start()
        childs.append(coordinator)
    }
    
    
}

extension MockCoordinator: SearchCoordinator {
    public func startBusStopFlow() {
    
    }
}

extension MockCoordinator: BusStopCoordinator {
    public func popVC() {
        navigationController.popViewController(animated: true)
        finish()
    }
    
    public func busStopMapLocation(busStopId: String) {
        let coordinator = MockCoordinator(
            testMessage: "Map",
            navigationController: navigationController
        )
        coordinator.start()
        childs.append(coordinator)
    }
}

extension MockCoordinator: AddRegularAlarmCoordinator {
    public func start(with: RegularAlarmResponse) {
        
    }
    
    public func startSearchFlow() {
        
    }
    
    public func complete() {
        
    }
}

extension MockCoordinator: NearMapCoordinator {
    
}
#endif
