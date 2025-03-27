//
//  MinVersionEndpoint.swift
//  NetworkService
//
//  Created by Jisoo Ham on 3/26/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Foundation

public struct MinVersionEndpoint: EndPoint {
    private var domain: String
    
    public var scheme: Scheme {
        .https
    }
    
    public var host: String {
        return domain
    }
    
    public var port: String {
        ""
    }
    
    public var path: String {
        return "/minVer"
    }
    
    public var query: [String: String] {
        return [:]
    }
    public var header: [String: String] {
        return [:]
    }
    
    public var body: [String: Any] {
        return [:]
    }
    
    public var method: HTTPMethod {
        return .get
    }
    
    public init(domain: String) {
        self.domain = domain
    }
}
