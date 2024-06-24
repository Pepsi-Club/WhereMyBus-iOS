//
//  AppStoreCheck.swift
//  App
//
//  Created by Jisoo Ham on 5/26/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core

import RxSwift

enum AppStoreError: Error {
    case invalidURL
    case noData
    case parsingError
    case networkError(Error)
}

public final class AppStoreCheck {
    /// 앱스토어에 등록된 앱의 ID
    static let appstoreID = Bundle.main
        .object(forInfoDictionaryKey: "APPSTORE_ID") as? String
    
    /// 앱스토어 연결 링크
    static let appStoreURLString
    = "itms-apps://itunes.apple.com/app/apple-store/"
    
    private init() { }
    
    /// 앱스토어에 등록된 최신 버전 가져오는 함수
    static public func latestVersion() -> Single<String> {
        return Single.create { single in
            Task {
                do {
                    guard let appstoreID = AppStoreCheck.appstoreID else {
                        throw AppStoreError.invalidURL
                    }
                    let urlString = "https://itunes.apple.com/lookup?id=\(appstoreID)&country=kr"
                    guard let url = URL(string: urlString) else {
                        throw AppStoreError.invalidURL
                    }

                    let (data, _) = try await URLSession
                        .shared.data(for: URLRequest(url: url))
                    let json = try JSONSerialization.jsonObject(
                        with: data,
                        options: .allowFragments
                    ) as? [String: Any]

                    guard let results = json?["results"] as? [[String: Any]],
                          let appStoreVersion = results.first?["version"] 
                            as? String else {
                        throw AppStoreError.parsingError
                    }
                    single(.success(appStoreVersion))
                } catch let error as AppStoreError {
                    single(.failure(error))
                } catch {
                    single(.failure(AppStoreError.networkError(error)))
                }
            }
            return Disposables.create()
        }
    }
    
    /// URL을 통해 앱스토어 오픈
    static public func openAppStore() {
        guard let appstoreID,
              let url = URL(
                string: AppStoreCheck.appStoreURLString + appstoreID
              )
        else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
