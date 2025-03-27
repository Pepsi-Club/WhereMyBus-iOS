//
//  AppInfoDTO.swift
//  Data
//
//  Created by Jisoo HAM on 8/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

public struct AppInfoDTO: Decodable {
    let resultCount: Int
    let results: [AppDetailDTO]
}

extension AppInfoDTO {
    var toDomain: AppVersionInfoResponse? {
        guard let versionString = results.map({ $0.version }).first 
        else { return nil }
        
        let versionComponents = versionString.split(separator: ".")
            .compactMap { Int($0) }
        
        guard versionComponents.count == 3 
        else { return nil }
        
        return AppVersionInfoResponse(
            major: versionComponents[0],
            minor: versionComponents[1],
            patch: versionComponents[2]
        )
    }
}

extension AppInfoDTO {
    struct AppDetailDTO: Decodable {
        let trackId: Int
        /// App Version
        let version: String
    }
}
