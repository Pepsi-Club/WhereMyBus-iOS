//
//  OpenStoreEndpoint.swift
//  NetworkService
//
//  Created by Jisoo Ham on 3/25/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Foundation

public struct OpenStoreEndpoint: EndPoint {
    private let appStoreID: String
    
    public var scheme: Scheme {
        return .itms
    }
    
    public var host: String {
        "itunes.apple.com"
    }
    
    public var port: String {
        ""
    }
    
    public var path: String {
        "/app/apple-store/\(appStoreID)"
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
    
    public init(appStoreID: String) {
        self.appStoreID = appStoreID
    }
}
