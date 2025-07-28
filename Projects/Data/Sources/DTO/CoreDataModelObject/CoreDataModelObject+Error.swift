//
//  CoreDataModelObject+Error.swift
//  Data
//
//  Created by gnksbm on 7/28/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import CoreData

import CoreDataService

enum DTOParsingError: LocalizedError {
    case missingAttribute(String)
    
    var errorDescription: String? {
        switch self {
        case .missingAttribute(let key):
            return "DTO 파싱 오류: '\(key)' 속성이 누락되었습니다."
        }
    }
}

protocol DTOParsable { }

extension DTOParsable {
    func unwrap<T>(_ keyPath: KeyPath<Self, T?>) throws -> T {
        guard let value = self[keyPath: keyPath] else {
            let key = keyPath._kvcKeyPathString ?? String(describing: keyPath)
            throw DTOParsingError.missingAttribute(key)
        }
        return value
    }
}
