//
//  CoreDataDirectory.swift
//  CoreDataService
//
//  Created by gnksbm on 4/17/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

enum CoreDataDirectory: Codable {
    case applicationSupport, appGroup
    
    var description: String {
        switch self {
        case .applicationSupport:
            return "마이그레이션 필요한 저장소"
        case .appGroup:
            return "마이그레이션 완료된 저장소"
        }
    }
}
