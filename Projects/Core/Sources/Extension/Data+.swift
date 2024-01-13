//
//  Data+.swift
//  Core
//
//  Created by gnksbm on 2023/12/30.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

public extension Data {
    func decode<T>(type: T.Type) throws -> T where T: Decodable {
        do {
            return try JSONDecoder().decode(type, from: self)
        } catch {
            throw error
        }
    }
}
