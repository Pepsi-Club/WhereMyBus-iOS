//
//  VersionCheckRepository.swift
//  Domain
//
//  Created by Jisoo HAM on 8/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol VersionCheckRepository: AnyObject {
    func fetchRequiredVersion()
    -> Single<Result<AppVersionInfoResponse, Error>>
    func getStoreLink() -> String?
    func getAppStoreID() -> String
    func getUserAppVersion() -> AppVersionInfoResponse
    func saveForceUpdateInfo(_ info: ForceUpdate)
    func getForceUpdateInfo() -> ForceUpdate
}
