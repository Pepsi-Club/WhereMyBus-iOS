//
//  DefaultVersionCheckRepository.swift
//  Data
//
//  Created by Jisoo HAM on 8/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Domain
import NetworkService

import RxSwift

public final class DefaultVersionCheckRepository: VersionCheckRepository {
    private let networkService: NetworkService
    private let disposeBag: DisposeBag = DisposeBag()
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func getAppVersion(appId: String) 
    -> Single<Result<AppVersionInfoResponse?, Error>> {
        return networkService.request(
            endPoint: AppStoreEndPoint(appStoreID: appId),
            responseType: AppInfoDTO.self
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
    
    public func getStoreLink(appId: String) -> String? {
        return OpenStoreEndpoint(appStoreID: appId).toURLString
    }
}
