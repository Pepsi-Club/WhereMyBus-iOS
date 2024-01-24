//
//  Coordinator.swift
//  PresentationDependency
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core

public protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
