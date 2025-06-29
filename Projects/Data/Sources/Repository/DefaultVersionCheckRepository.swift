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

import RxSwift

public final class DefaultVersionCheckRepository: VersionCheckRepository {
    @Injected private var networkService: NetworkService
    
    @UserDefaultsWrapper(
        key: "ForceUpdate",
        defaultValue: ForceUpdate(
            version: AppVersionInfoResponse(major: 1, minor: 2, patch: 4),
            date: Date(timeIntervalSince1970: 0)
        )
    )
    private var forceUpdateInfo: ForceUpdate
    
    public init() { }
    
    /// 서버로 부터 받은 App의 최소 지원 버전
    public func fetchRequiredVersion() async throws -> AppVersionInfoResponse {
        try await networkService.request(endPoint: MinVersionEndpoint(domain: getDomainURL()))
            .decode(type: RequiredVersionDTO.self)
            .toDomain
    }
    
    public func fetchRequiredVersion()
    -> Single<Result<AppVersionInfoResponse, Error>> {
        return networkService.request(
            endPoint: MinVersionEndpoint(domain: getDomainURL()),
            responseType: RequiredVersionDTO.self
        )
        .map { result in
            switch result {
            case .success(let value):
                return .success(value.toDomain)
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    public func getStoreLink() -> String? {
        return OpenStoreEndpoint(appStoreID: getAppStoreID()).toURLString
    }
    
    public func getAppStoreID() -> String {
        guard let appId = Bundle.main.object(
            forInfoDictionaryKey: "APPSTORE_ID"
        ) as? String
        else { return "" }
        
        return appId
    }
    
    public func getUserAppVersion() -> AppVersionInfoResponse {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String
        else { return AppVersionInfoResponse(major: 1, minor: 0, patch: 0) }
        
        let splitedVersion = version.split(separator: ".")
            .compactMap { Int($0) }
        
        return AppVersionInfoResponse(
            major: splitedVersion[0],
            minor: splitedVersion[1],
            patch: splitedVersion[2]
        )
    }
    
    /// 최소 요구 버전, fetch 받은 날짜를 UserDefaults 저장
    public func saveForceUpdateInfo(_ newValue: ForceUpdate) {
        forceUpdateInfo = newValue
    }
    
    /// UserDefaults 저장된 최소 요구 버전, fetch 받은 날짜
    public func getForceUpdateInfo() -> ForceUpdate {
        return forceUpdateInfo
    }
    
    private func getDomainURL() -> String {
        guard let domainURL = Bundle.main.object(
            forInfoDictionaryKey: "DOMAIN_URL"
        ) as? String
        else { return "" }
        
        return domainURL
    }
}
