//
//  FetchRegularAlarmDTO.swift
//  Data
//
//  Created by gnksbm on 4/14/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

struct FetchRegularAlarmDTO: Decodable {
    let alarmId: String
    let time: String
    let weekday: [Int]
    let busId: String
    let busStopId: String
//    let adirection: String
}

extension Array<FetchRegularAlarmDTO> {
    func validateSync(
        localResponses: [RegularAlarmResponse]
    ) -> RegularAlarmSyncValidation {
        let (serverMissingAlarms, localMissingAlarm) = compareDiff(
            sourceKeyPath: \.alarmId,
            target: localResponses,
            targetKeyPath: \.requestId
        )
        let localMissingAlarmIds = localMissingAlarm.map { $0.alarmId }
        return RegularAlarmSyncValidation(
            localMissingAlarmIds: localMissingAlarmIds,
            serverMissingAlarms: serverMissingAlarms
        )
    }
}

extension FetchRegularAlarmDTO {
    enum CodingKeys: String, CodingKey {
        case alarmId = "id"
        case time
        case weekday = "day"
        case busId = "busRoutedId"
        case busStopId = "arsId"
//        case adirection
    }
}
