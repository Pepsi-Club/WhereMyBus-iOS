//
//  Coordinator.swift
//  PresentationDependency
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core

public protocol Coordinator: AnyObject {
    var parent: Coordinator? { get set }
    var childs: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    
    func start()
    func finish()
}

public extension Coordinator {
    func finish() {
        parent?.childDidFinish(self)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        childs = childs.filter { $0 !== child }
    }
}
