//
//  SearchResponse.swift
//  Domain
//
//  Created by 유하은 on 2024/02/27.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct SearchResponse: Hashable {
    public let busStopName: String
    public let busStopId: String
    public let direction: String
    
    public init(
        busStopName: String,
        busStopId: String,
        direction: String
    ) {
        self.busStopId = busStopId
        self.busStopName = busStopName
        self.direction = direction
    }
}
