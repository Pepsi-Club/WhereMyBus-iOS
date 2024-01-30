//
//  ArrivalInfoRequest.swift
//  Domain
//
//  Created by gnksbm on 1/28/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct ArrivalInfoRequest {
    public let busStopId: String
    public let busStopName: String
    public let routeName: [String]
    
    public init(
        busStopId: String, 
        busStopName: String, 
        routeName: [String]
    ) {
        self.busStopId = busStopId
        self.busStopName = busStopName
        self.routeName = routeName
    }
}
