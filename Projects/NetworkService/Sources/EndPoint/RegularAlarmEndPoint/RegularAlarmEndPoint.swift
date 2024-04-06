//
//  RegularAlarmEndPoint.swift
//  NetworkService
//
//  Created by gnksbm on 4/4/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public protocol RegularAlarmEndPoint: EndPoint { }

public extension RegularAlarmEndPoint {
    var scheme: Scheme {
        .https
    }
    
    var host: String {
        "api.wherebybus.shop"
    }
    
    var path: String {
        "/regular"
    }
}
