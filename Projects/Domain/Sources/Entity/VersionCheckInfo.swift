//
//  VersionCheckInfo.swift
//  Domain
//
//  Created by gnksbm on 7/5/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Foundation

public struct VersionCheckInfo: Codable {
    public let requiredVersion: AppVersionInfoResponse
    public let updatedAt: Date
    
    public init(requiredVersion: AppVersionInfoResponse, updatedAt: Date) {
        self.requiredVersion = requiredVersion
        self.updatedAt = updatedAt
    }
}
