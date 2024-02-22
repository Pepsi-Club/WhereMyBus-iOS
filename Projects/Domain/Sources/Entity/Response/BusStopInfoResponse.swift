//
//  BusStopInfoResponse.swift
//  Domain
//
//  Created by gnksbm on 1/28/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct BusStopInfoResponse {
    public let name: String
    public let busStopId: String
    public let longitude: String
    public let latitude: String
    public let busStopNum: String
    
    public init(
        name: String, 
        busStopId: String,
        longitude: String,
        latitude: String,
        busStopNum: String
    ) {
        self.name = name
        self.busStopId = busStopId
        self.longitude = longitude
        self.latitude = latitude
        self.busStopNum = busStopNum
    }
}
