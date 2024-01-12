//
//  Encodable+.swift
//  Core
//
//  Created by gnksbm on 2023/12/30.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

public extension Encodable {
    func encode() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
