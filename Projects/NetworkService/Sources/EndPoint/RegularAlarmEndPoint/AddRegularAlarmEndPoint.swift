//
//  AddRegularAlarmEndPoint.swift
//  NetworkService
//
//  Created by gnksbm on 3/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain

public struct AddRegularAlarmEndPoint: RegularAlarmEndPoint {
    private let request: AddRegularAlarmRequest
    
    public var port: String {
        ""
    }
    
    public var query: [String: String] {
        [:]
    }
    
    public var header: [String: String] {
        [
            "content-type": "application/json",
        ]
    }
    
    public var body: [String: Any] {
        [
            "deviceToken": String.fcmToken ?? "",
            "time": request.time,
            "day": request.weekday,
            "busRouteId": request.busRouteId,
            "arsId": request.arsId,
        ]
    }
    
    public var method: HTTPMethod {
        .post
    }
    
    public init(request: AddRegularAlarmRequest) {
        self.request = request
    }
}
