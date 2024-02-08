//
//  AddRegularAlarmCoordinator.swift
//  AlarmFeature
//
//  Created by gnksbm on 2/2/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public protocol AddRegularAlarmCoordinator: Coordinator {
    func start(with: String)
    func startSearchFlow()
    func complete()
}
