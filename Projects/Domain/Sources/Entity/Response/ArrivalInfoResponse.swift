//
//  ArrivalInfoResponse.swift
//  Domain
//
//  Created by gnksbm on 1/26/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

//import RxDataSources

public struct ArrivalInfoResponse {
    public let busStopName: String
    public let busStopDirection: String
    public var items: [RouteArrivalInfo]
    
    public init(
        busStopName: String,
        busStopDirection: String,
        items: [RouteArrivalInfo]
    ) {
        self.busStopName = busStopName
        self.busStopDirection = busStopDirection
        self.items = items
    }
}

//extension ArrivalInfoResponse: SectionModelType {
//    public init(
//        original: ArrivalInfoResponse,
//        items: [RouteArrivalInfo]
//    ) {
//        self = original
//        self.items = items
//    }
//    
//    public typealias Item = RouteArrivalInfo
//}

public struct RouteArrivalInfo {
    public let routeName: String
    public let firstArrivalTime: String
    public let firstArrivalRemaining: String
    public let secondArrivalTime: String
    public let secondArrivalRemaining: String
    
    public init(
        routeName: String,
        firstArrivalTime: String,
        firstArrivalRemaining: String,
        secondArrivalTime: String,
        secondArrivalRemaining: String
    ) {
        self.routeName = routeName
        self.firstArrivalTime = firstArrivalTime
        self.firstArrivalRemaining = firstArrivalRemaining
        self.secondArrivalTime = secondArrivalTime
        self.secondArrivalRemaining = secondArrivalRemaining
    }
}
