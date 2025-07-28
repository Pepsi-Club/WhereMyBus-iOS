//
//  AppVersionCheckUseCase.swift
//  Domain
//
//  Created by Jisoo Ham on 3/25/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Foundation

public protocol AppVersionCheckUseCase {
    func checkForceUpdateNeeded() async throws -> ForceUpdate
}
