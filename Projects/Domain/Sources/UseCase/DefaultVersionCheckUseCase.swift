//
//  DefaultVersionCheckUseCase.swift
//  Domain
//
//  Created by Jisoo Ham on 3/25/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

import RxSwift

public final class VersionCheckUseCaseImpl: VersionCheckUseCase {
    @Injected private var versionCheckRepository: VersionCheckRepository
    private let currentVersion: AppVersionInfoResponse

    public init(currentVersion: AppVersionInfoResponse) {
        self.currentVersion = currentVersion
    }
    
    public func checkForceUpdateNeeded() async throws -> ForceUpdate {
        if let cachedInfo = versionCheckRepository.getCachedVersionCheckInfo() {
            if cachedInfo.requiredVersion > currentVersion {
                return .needed(appStoreURL: try versionCheckRepository.getAppStoreURL())
            }
            if cachedInfo.updatedAt.distance(to: .now) < .hour(4) {
                return .notNeeded
            }
        }
        let fetchedRequiredVersion = try await versionCheckRepository.fetchRequiredVersion()
        versionCheckRepository.saveVersionCheckInfoCache(
            VersionCheckInfo(requiredVersion: fetchedRequiredVersion, updatedAt: .now)
        )
        if fetchedRequiredVersion > currentVersion {
            return .needed(appStoreURL: try versionCheckRepository.getAppStoreURL())
        }
        return .notNeeded
    }
}
