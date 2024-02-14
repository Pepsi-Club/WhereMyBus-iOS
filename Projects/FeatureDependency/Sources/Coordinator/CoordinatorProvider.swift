//
//  CoordinatorProvider.swift
//  FeatureDependency
//
//  Created by gnksbm on 1/26/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public protocol CoordinatorProvider {
    func makeSearchCoordinator(
        navigationController: UINavigationController
    ) -> SearchCoordinator
    
//    func makeBusStopMapCoordinator(
//        navigationController: UINavigationController
//    ) -> NearMapCoordinator

    func makeAddRegularAlarmCoordinator(
        navigationController: UINavigationController
    ) -> AddRegularAlarmCoordinator
}
