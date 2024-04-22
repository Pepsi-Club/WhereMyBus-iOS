//
//  Array+.swift
//  Core
//
//  Created by gnksbm on 4/17/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public extension Array where Element: Hashable {
    /// 중복을 제거한 배열 리턴
    func removeDuplicated() -> Self {
        Array(Set(self))
    }
}
