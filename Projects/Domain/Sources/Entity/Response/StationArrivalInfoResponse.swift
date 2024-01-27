//
//  StationArrivalInfoResponse.swift
//  Domain
//
//  Created by gnksbm on 1/26/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct StationArrivalInfoResponse {
    public let busRoute: String
    public let busDirection: String
    public let firstArrivalTime: String
    public let firstArrivalRemaining: String
    public let secondArrivalTime: String
    public let secondArrivalRemaining: String
    
    public init(
        busRoute: String,
        busDirection: String,
        firstArrivalTime: String,
        firstArrivalRemaining: String,
        secondArrivalTime: String,
        secondArrivalRemaining: String
    ) {
        self.busRoute = busRoute
        self.busDirection = busDirection
        self.firstArrivalTime = firstArrivalTime
        self.firstArrivalRemaining = firstArrivalRemaining
        self.secondArrivalTime = secondArrivalTime
        self.secondArrivalRemaining = secondArrivalRemaining
    }
}
