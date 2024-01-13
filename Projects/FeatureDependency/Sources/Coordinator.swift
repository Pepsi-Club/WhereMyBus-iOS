//
//  Coordinator.swift
//  FeatureDependency
//
//  Created by gnksbm on 2023/11/25.
//  Copyright © 2023 gnksbm All rights reserved.
//

import UIKit

public protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    
    func start()
}
