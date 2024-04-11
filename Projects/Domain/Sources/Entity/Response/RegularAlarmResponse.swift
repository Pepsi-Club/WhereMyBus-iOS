//
//  RegularAlarmResponse.swift
//  Domain
//
//  Created by gnksbm on 2/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

public struct RegularAlarmResponse: Hashable, CoreDataStorable {
    public let requestId: String
    public let busStopId: String
    public let busStopName: String
    public let busId: String
    public let busName: String
    public let time: Date
    public let weekday: [Int]
    
    public init(
        requestId: String = UUID().uuidString,
        busStopId: String,
        busStopName: String, 
        busId: String, 
        busName: String,
        time: Date,
        weekday: [Int]
    ) {
        self.requestId = requestId
        self.busStopId = busStopId
        self.busStopName = busStopName
        self.busId = busId
        self.busName = busName
        self.time = time
        self.weekday = weekday as [Int]
    }
}

public extension RegularAlarmResponse {
    var toAddRequest: AddRegularAlarmRequest {
        .init(
            date: time,
            weekday: weekday,
            busRouteId: busId,
            arsId: busStopId,
            busStopName: busStopName,
            busName: busName
        )
    }
    
    var toRemoveRequest: RemoveRegularAlarmRequest {
        .init(alarmId: requestId)
    }
}
