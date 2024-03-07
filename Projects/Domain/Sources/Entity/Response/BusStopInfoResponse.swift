//
//  BusStopInfoResponse.swift
//  Domain
//
//  Created by gnksbm on 1/28/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct BusStopInfoResponse {
    public let busStopName: String
    public let busStopId: String // 기존 ID가 아닌 5자리 ID(busStopNum)
    public let direction: String? // 데이터 보충 전까진 옵셔널로 사용
    public let longitude: String
    public let latitude: String
    
    public init(
        busStopName: String,
        busStopId: String,
        direction: String?,
        longitude: String,
        latitude: String
    ) {
        self.busStopName = busStopName
        self.busStopId = busStopId
        self.direction = direction
        self.longitude = longitude
        self.latitude = latitude
    }
}
