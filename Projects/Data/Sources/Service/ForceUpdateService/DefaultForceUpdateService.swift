//
//  DefaultForceUpdateService.swift
//  Data
//
//  Created by Jisoo Ham on 3/27/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

public final class DefaultForceUpdateService: ForceUpdateService {
    public init() { }
    
    public func compareVersion(
        user: AppVersionInfoResponse,
        required: AppVersionInfoResponse
    ) -> Bool {
        return required > user
    }
}
