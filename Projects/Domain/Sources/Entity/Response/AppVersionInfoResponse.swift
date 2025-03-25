//
//  AppVersionInfoResponse.swift
//  Domain
//
//  Created by Jisoo HAM on 8/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct AppVersionInfoResponse {
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
}
