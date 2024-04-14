//
//  RegularAlarmSyncValidation.swift
//  Data
//
//  Created by gnksbm on 4/14/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain

enum RegularAlarmSyncValidation {
    case synced
    case localMissing(alarmIds: [String])
    case serverMissing(responses: [RegularAlarmResponse])
    case bothMissing(
        localMissingAlarmIds: [String],
        serverMissingResponses: [RegularAlarmResponse]
    )
    
    init(
        localMissingAlarmIds: [String],
        serverMissingAlarms: [RegularAlarmResponse]
    ) {
        let isLocalMissed = !localMissingAlarmIds.isEmpty
        let isServerMissed = !serverMissingAlarms.isEmpty
        switch (isLocalMissed, isServerMissed) {
        case (false, false):
            self = .synced
        case (true, false):
            self = .localMissing(alarmIds: localMissingAlarmIds)
        case (false, true):
            self = .serverMissing(responses: serverMissingAlarms)
        case (true, true):
            self = .bothMissing(
                localMissingAlarmIds: localMissingAlarmIds,
                serverMissingResponses: serverMissingAlarms
            )
        }
    }
}
