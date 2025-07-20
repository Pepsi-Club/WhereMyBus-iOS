//
//  RegularAlarmCoordinator.swift
//  AlarmFeature
//
//  Created by gnksbm on 7/19/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Foundation

public protocol RegularAlarmCoordinator: Coordinator {
    func startAddRegularAlarmFlow()
    func startAddRegularAlarmFlow(with: RegularAlarmResponse)
}
