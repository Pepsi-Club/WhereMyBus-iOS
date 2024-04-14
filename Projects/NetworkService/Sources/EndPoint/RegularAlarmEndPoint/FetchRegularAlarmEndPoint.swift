//
//  FetchRegularAlarmEndPoint.swift
//  NetworkService
//
//  Created by gnksbm on 4/14/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

public struct FetchRegularAlarmEndPoint: RegularAlarmEndPoint {
    public var port: String {
        ""
    }
    
    public var query: [String: String] {
        ["deviceToken": .fcmToken ?? ""]
    }
    
    public var header: [String: String] {
        [:]
    }
    
    public var body: [String: Any] {
        [:]
    }
    
    public var method: HTTPMethod {
        .get
    }
    
    public init() { }
}
