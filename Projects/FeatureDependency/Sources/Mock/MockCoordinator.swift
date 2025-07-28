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
    
    public var busStopCoordinatorDelegate: BusStopCoordinatorDelegate?
    
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
        let testLabel = UILabel()
        testLabel.text = testMessage
        testLabel.numberOfLines = 0
        testLabel.font = .boldSystemFont(ofSize: 20)
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        testViewController.view.addSubview(testLabel)
        NSLayoutConstraint.activate([
            testLabel.centerXAnchor.constraint(
                equalTo: testViewController.view.centerXAnchor
            ),
            testLabel.centerYAnchor.constraint(
                equalTo: testViewController.view.centerYAnchor
            ),
        ])
        navigationController.pushViewController(
            testViewController,
            animated: true
        )
    }
}

extension MockCoordinator: SearchCoordinator {
    public func startNearMapFlow(busStopID: String) {
        let coordinator = MockCoordinator(
            testMessage: "\(#function)",
            navigationController: navigationController
        )
        coordinator.start()
        childs.append(coordinator)
    }
    
    public func startNearMapFlow() {
        let coordinator = MockCoordinator(
            testMessage: "\(#function)",
            navigationController: navigationController
        )
        coordinator.start()
        childs.append(coordinator)
    }
    
    public func startBusStopFlow(busStopID: String) {
        let coordinator = MockCoordinator(
            testMessage: "\(#function)",
            navigationController: navigationController
        )
        coordinator.start()
        childs.append(coordinator)
    }
    
    public func finishFlow() {
        navigationController.popViewController(animated: true)
        finish()
    }
}


extension MockCoordinator: BusStopCoordinator {
    public var delegate: BusStopCoordinatorDelegate? { busStopCoordinatorDelegate }
    
    public func example() {
        
    }
    
    
    public func popVC() {
        
    }
    
    public func moveToRegualrAlarm() {
        
    }
    
    public func busStopMapLocation(busStopId: String) {
        let coordinator = MockCoordinator(
            testMessage: "Map - busStopId: \(busStopId)",
            navigationController: navigationController
        )
        coordinator.start()
        childs.append(coordinator)
    }
}

#endif
