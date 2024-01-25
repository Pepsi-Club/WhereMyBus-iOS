//
//  StationArrivalInfoEndPoint.swift
//  Networks
//
//  Created by gnksbm on 1/25/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

public struct StationArrivalInfoEndPoint: EndPoint {
    let stationId: String
    
    public var scheme: Scheme {
        .http
    }
    
    public var host: String {
        "ws.bus.go.kr"
    }
    
    public var port: String {
        ""
    }
    
    public var path: String {
        "/api/rest/arrive/getLowArrInfoByStId"
    }
    
    public var query: [String : String] {
        [
            "ServiceKey": .serverKey,
            "stId": stationId
        ]
    }
    
    public var header: [String : String] {
        [:]
    }
    
    public var body: [String : String] {
        [:]
    }
    
    public var method: HTTPMethod {
        .get
    }
    
    public init(stationId: String) {
        self.stationId = stationId
    }
}
// http://ws.bus.go.kr/api/rest/arrive/getLowArrInfoByStId?ServiceKey=Lk%2FrcEMNxmVQdKclcu7dRxe5KiRfBGRdxiZMI3lNDwuvwYbs1VCVrSg8dCGBieouCSEs4%2FBArQAHyUBv65sP5Q%3D%3D&stId=121000214
