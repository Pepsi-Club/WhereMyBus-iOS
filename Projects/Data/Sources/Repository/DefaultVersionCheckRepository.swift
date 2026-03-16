//
//  DefaultVersionCheckRepository.swift
//  Data
//
//  Created by Jisoo HAM on 8/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core
import Domain
import NetworkService

public final class VersionCheckRepositoryImpl: VersionCheckRepository {
    @Injected private var networkService: NetworkService
    
    @UserDefaultsWrapper(key: "ForceUpdate")
    var versionCheckInfo: VersionCheckInfo?
    
    private let appStoreID: String
    private let domainURL: String
    
    public init(appStoreID: String, domainURL: String) {
        self.appStoreID = appStoreID
        self.domainURL = domainURL
    }
    
    public func getCachedVersionCheckInfo() -> VersionCheckInfo? {
        versionCheckInfo
    }
    
    public func fetchRequiredVersion() async throws -> AppVersionInfoResponse {
        try await networkService.request(
            endPoint: MinVersionEndpoint(domain: domainURL)
        )
        .decode(type: RequiredVersionDTO.self)
        .toDomain
    }
    
    public func saveVersionCheckInfoCache(_ versionCheckInfo: VersionCheckInfo) {
        self.versionCheckInfo = versionCheckInfo
    }
    
    public func getAppStoreURL() throws -> URL {
        try OpenStoreEndpoint(appStoreID: appStoreID).toURL
    }
}
