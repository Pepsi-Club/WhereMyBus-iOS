//
//  TimeInterval+.swift
//  Core
//
//  Created by gnksbm on 7/5/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Foundation

public extension TimeInterval {
    static func hour(_ value: Int) -> Self {
        Self(value) * 60 * 60
    }
}
