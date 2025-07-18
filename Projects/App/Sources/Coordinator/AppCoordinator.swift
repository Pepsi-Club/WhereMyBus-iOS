//
//  AppCoordinator.swift
//  YamYamPick
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import UIKit

import FeatureDependency
import BusStopFeature
import Domain

protocol AppCoordinatorDependency: AnyObject, SplashViewModelDependency {
    var sceneWillEnterForeground: AsyncStream<UIScene> { get }
    var appVersion: AppVersionInfoResponse { get }
    var appStoreID: String { get }
    var domainURL: String { get }
}

final class AppCoordinator: Coordinator {
    var parent: Coordinator?
    var childs: [Coordinator] = []
    var navigationController: UINavigationController
    public var coordinatorType: CoordinatorType = .app
    private let coordinatorProvider = DefaultCoordinatorProvider()
    private let dependency: AppCoordinatorDependency
    
    init(
        navigationController: UINavigationController,
        dependency: AppCoordinatorDependency
    ) {
        self.navigationController = navigationController
        self.dependency = dependency
    }
    
    func start() {
        let splashCoordinator = SplashCoordinatorImpl(
            parent: self,
            navigationController: navigationController,
            coordinatorProvider: coordinatorProvider,
            homeCoordinatorBuilder: coordinatorProvider,
            viewModelDependency: dependency
        )
        childs.append(splashCoordinator)
        splashCoordinator.start()
    }
    
    func startBusStopFlow(busStopId: String) {
        let busStopCoordinator = DefaultBusStopCoordinator(
            parent: self,
            navigationController: navigationController,
            busStopId: busStopId,
            coordinatorProvider: coordinatorProvider,
            flow: .fromHome,
            nearMapCoordinatorBuilder: coordinatorProvider
        )
        childs.append(busStopCoordinator)
        busStopCoordinator.start()
    }
    
    func openURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
