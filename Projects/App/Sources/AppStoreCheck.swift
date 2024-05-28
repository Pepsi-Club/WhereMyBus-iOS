//
//  AppStoreCheck.swift
//  App
//
//  Created by Jisoo Ham on 5/26/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core

public final class AppStoreCheck {
    /// 앱스토어에 등록된 앱의 ID
    static let appstoreID = Bundle.main.object(forInfoDictionaryKey: "APPSTORE_ID") as? String
    
    /// 앱스토어 연결 링크
    static let appStoreURLString
    = "itms-apps://itunes.apple.com/app/apple-store/"
    
    /// 앱스토어에 등록된 최신 버전 가져오는 함수
    
    static public func latestVersion() async -> String? {
        guard let appstoreID = AppStoreCheck.appstoreID,
              let url
                = URL(string: "https://itunes.apple.com/lookup?id=\(appstoreID)&country=kr")
        else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(
                for: URLRequest(url: url)
            )
            
            guard let json = try? JSONSerialization.jsonObject(
                with: data,
                options: .allowFragments
            ) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results[0]["version"] as? String
            else {
                return nil
            }
            
            return appStoreVersion
        } catch {
            return nil
        }
    }
    
    /// URL을 통해 앱스토어 오픈
    static public func openAppStore() {
        guard let appstoreID,
              let url = URL(string: AppStoreCheck.appStoreURLString + appstoreID)
        else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
