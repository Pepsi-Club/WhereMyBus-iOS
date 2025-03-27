//
//  DefaultVersionCheckUseCase.swift
//  Domain
//
//  Created by Jisoo Ham on 3/25/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public final class DefaultVersionCheckUseCase: VersionCheckUseCase {
    private let versionCheckRepository: VersionCheckRepository
    private let forceUpdateService: ForceUpdateService
    
    public init(
        versionCheckRepository: VersionCheckRepository,
        forceUpdateService: ForceUpdateService
    ) {
        self.versionCheckRepository = versionCheckRepository
        self.forceUpdateService = forceUpdateService
    }
    
    public func fetchAppStoreURL() -> Single<String?> {
        if hasToFetchVersion() {
            return fetchAndUpdateVersion()
        } else {
            let forceUpdateInfo = versionCheckRepository.getForceUpdateInfo()
            return .just(getStoreLink(forceUpdateInfo.version))
        }
    }
}
extension DefaultVersionCheckUseCase {
    /// 호출하는 시점과 UserDefaults에 저장된 Date를 기준으로 4시간이 넘는지를 확인하는 method
    private func hasToFetchVersion() -> Bool {
        let fourHour: TimeInterval = 4 * 60 * 60
        
        return Date().timeIntervalSince(
            versionCheckRepository.getForceUpdateInfo().date
        ) >= fourHour
    }
    
    private func fetchAndUpdateVersion() -> Single<String?> {
        return versionCheckRepository.fetchRequiredVersion()
            .do(onSuccess: { [weak self] result in
                guard let self else { return }
                saveForceVersionInfo(result)
            })
            .map { [weak self] result in
                guard let self else { return nil }
                return handleFetchedResult(result)
            }
    }
    
    /// 서버 통신의 결과 상태를 기반으로 app store Link 반환
    private func handleFetchedResult(
        _ result: Result<AppVersionInfoResponse, Error>
    ) -> String? {
        switch result {
        case .success(let version):
            return getStoreLink(version)
        case .failure:
            return nil
        }
    }
    
    /// 결과값에 따라 ForceUpdate 타입의 info들을 UserDefaults에 저장
    private func saveForceVersionInfo(
        _ result: Result<AppVersionInfoResponse, Error>
    ) {
        switch result {
        case .success(let version):
            let forceUpdate = ForceUpdate(
                version: version,
                date: Date()
            )
            versionCheckRepository.saveForceUpdateInfo(forceUpdate)
        case .failure(let error):
            print(error)
        }
    }
    
    /// Get app store url after comparing version
    private func getStoreLink(_ required: AppVersionInfoResponse) -> String? {
        return forceUpdateService.compareVersion(
            user: versionCheckRepository.getUserAppVersion(),
            required: required
        ) ? versionCheckRepository.getStoreLink() : nil
    }
}
