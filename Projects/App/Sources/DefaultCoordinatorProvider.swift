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

final class DefaultCoordinatorProvider: CoordinatorProvider {
    func makeSearchCoordinator(
        navigationController: UINavigationController
    ) -> SearchCoordinator {
        DefaultSearchCoordinator(navigationController: navigationController)
    }
}
