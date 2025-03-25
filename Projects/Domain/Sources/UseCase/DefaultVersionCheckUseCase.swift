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
    private let disposeBag = DisposeBag()
    
    public init(versionCheckRepository: VersionCheckRepository) {
        self.versionCheckRepository = versionCheckRepository
    }
    
    public func fetchAppStoreURL(appId: String) -> Single<String?> {
        return versionCheckRepository.getAppVersion(appId: appId)
            .map { [weak self] result in
                guard let self else { return nil}
                switch result {
                case .success(let version):
                    return fetchURLString(
                        needsToUpdate(version),
                        appId: appId
                    )
                case .failure(let error):
                    print(error, #function)
                    return nil
                }
            }
    }
    
    /// 업데이트가 필요하다면 urlString return
    private func fetchURLString(
        _ isNeeded: Bool,
        appId: String
    ) -> String? {
        if isNeeded {
            return versionCheckRepository.getStoreLink(appId: appId)
        } else {
            return nil
        }
    }
    
    /// 앱스토어의 버전과 과 유저의 앱 버전의 major만을 비교하여 Bool 값을 return
    private func needsToUpdate(_ version: AppVersionInfoResponse?) -> Bool {
        guard let version else { return false }
        print(version.major, getUserVersion().major)
        return version.major > getUserVersion().major ? true : false
    }
    
    /// User가 사용하는 현재 앱 버전을 확인하기 위한 method
    private func getUserVersion() -> AppVersionInfoResponse {
        let splitCurrentVersion = String.getCurrentVersion()
        return AppVersionInfoResponse(
            major: splitCurrentVersion[0],
            minor: splitCurrentVersion[1],
            patch: splitCurrentVersion[2]
        )
    }
}
