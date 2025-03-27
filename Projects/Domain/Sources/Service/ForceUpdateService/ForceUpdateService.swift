//
//  ForceUpdateService.swift
//  Domain
//
//  Created by Jisoo Ham on 3/27/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Foundation

public protocol ForceUpdateService {
    func compareVersion(
        user: AppVersionInfoResponse,
        required: AppVersionInfoResponse
    ) -> Bool
}
