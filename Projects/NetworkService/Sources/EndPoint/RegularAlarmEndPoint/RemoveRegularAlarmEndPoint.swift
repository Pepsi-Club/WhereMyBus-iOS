//
//  RemoveRegularAlarmEndPoint.swift
//  NetworkService
//
//  Created by gnksbm on 4/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain

public struct RemoveRegularAlarmEndPoint: RegularAlarmEndPoint {
    private let request: RemoveRegularAlarmRequest
    
    public var port: String {
        ""
    }
    
    public var query: [String: String] {
        [
            "deviceToken": String.fcmToken ?? "",
            "alarmId": request.alarmId
        ]
    }
    
    public var header: [String: String] {
        [:]
    }
    
    public var body: [String: Any] {
        [:]
    }
    
    public var method: HTTPMethod {
        .delete
    }
    
    public init(request: RemoveRegularAlarmRequest) {
        self.request = request
    }
}
