//
//  RegularAlarmResponse.swift
//  Domain
//
//  Created by gnksbm on 2/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct RegularAlarmResponse: Hashable {
    public let busStopId: String
    public let busStopName: String
    public let busId: String
    public let busName: String
    public let time: Date
    public let weekDay: [Int]
}
