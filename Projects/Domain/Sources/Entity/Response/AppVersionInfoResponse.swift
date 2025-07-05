//
//  AppVersionInfoResponse.swift
//  Domain
//
//  Created by Jisoo HAM on 8/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct AppVersionInfoResponse: Codable, Comparable {
    public static let defaultVersion: Self = .init(major: 1, minor: 0, patch: 0)
    
    let major: Int
    let minor: Int
    let patch: Int
    
    public init(
        major: Int,
        minor: Int,
        patch: Int
    ) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    public static func < (
        lhs: AppVersionInfoResponse,
        rhs: AppVersionInfoResponse
    ) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        return lhs.patch < rhs.patch
    }
}
