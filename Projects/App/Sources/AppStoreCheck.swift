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
    
    /// 프로젝트 버전
    let appVersion = String.getCurrentVersion()
    
    /// 앱스토어에 등록된 앱의 ID
    static let appleID = Bundle.main.object(forInfoDictionaryKey: "APPLE_ID") as? String
    
    /// 앱스토어 연결 링크
    static let appStoreURLString
    = "itms-apps://itunes.apple.com/app/apple-store/"
    
    /// 앱스토어에 등록된 최신 버전 가져오는 함수
    static public func latestVersion(completion: @escaping (String?) -> Void) {
        guard let appleID = AppStoreCheck.appleID,
              let url = URL(
                string: "https://itunes.apple.com/lookup?id=\(appleID)&country=kr"
              )
        else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, err in
            guard let data,
                  let json = try? JSONSerialization.jsonObject(
                    with: data,
                    options: .allowFragments
                  ) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results[0]["version"] as? String
            else {
                completion(nil)
                return
            }
            
            completion(appStoreVersion)
        }
        
        task.resume()
    }
}
