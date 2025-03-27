//
//  RequiredVersionDTO.swift
//  Data
//
//  Created by Jisoo Ham on 3/26/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

public struct RequiredVersionDTO: Decodable {
    let version: String
    
    enum CodingKeys: String, CodingKey {
        case version = "ver"
    }
}

extension RequiredVersionDTO {
    var toDomain: AppVersionInfoResponse {
        let versionComponents = version.split(separator: ".")
            .compactMap { Int($0) }
        
        guard versionComponents.count == 3
        else { return AppVersionInfoResponse(major: 1, minor: 2, patch: 5) }
        
        return AppVersionInfoResponse(
            major: versionComponents[0],
            minor: versionComponents[1],
            patch: versionComponents[2]
        )
    }
}
