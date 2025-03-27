//
//  ForceUpdate.swift
//  Domain
//
//  Created by Jisoo Ham on 3/27/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Foundation

public struct ForceUpdate: Codable {
    let version: AppVersionInfoResponse
    let date: Date
    
    public init(
        version: AppVersionInfoResponse,
        date: Date
    ) {
        self.version = version
        self.date = date
    }
}
