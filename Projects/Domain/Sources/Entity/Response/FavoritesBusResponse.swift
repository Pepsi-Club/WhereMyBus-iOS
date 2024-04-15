//
//  FavoritesBusResponse.swift
//  Domain
//
//  Created by gnksbm on 4/16/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

public struct FavoritesBusResponse: CoreDataStorable {
    public let busStopId: String
    public let busStopName: String
    public let busId: String
    public let busName: String
    public let adirection: String
    
    public init(
        busStopId: String,
        busStopName: String,
        busId: String,
        busName: String,
        adirection: String
    ) {
        self.busStopId = busStopId
        self.busStopName = busStopName
        self.busId = busId
        self.busName = busName
        self.adirection = adirection
    }
}
