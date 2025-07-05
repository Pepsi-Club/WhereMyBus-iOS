//
//  VersionCheckRepository.swift
//  Domain
//
//  Created by Jisoo HAM on 8/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public protocol VersionCheckRepository: AnyObject {
    func getCachedVersionCheckInfo() -> VersionCheckInfo?
    func fetchRequiredVersion() async throws -> AppVersionInfoResponse
    func saveVersionCheckInfoCache(_ versionCheckInfo: VersionCheckInfo)
    func getAppStoreURL() throws -> URL
}
