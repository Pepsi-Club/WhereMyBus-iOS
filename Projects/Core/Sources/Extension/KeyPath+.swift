//
//  KeyPath+.swift
//  Core
//
//  Created by gnksbm on 3/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public extension KeyPath {
    /// 키패스 경로의 프로퍼티 이름
    var propertyName: String {
        guard let propertyName = String(describing: self)
            .components(separatedBy: ".")
            .last
        else { fatalError(#function) }
        return propertyName
    }
}
