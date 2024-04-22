//
//  Data+.swift
//  Core
//
//  Created by gnksbm on 2023/12/30.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

public extension Data {
    /**
     JSONDecoder로 디코딩
     - Parameters:
        - type: Decodable을 채택한 타입
     - Returns: 디코딩 성공 객체
     */
    func decode<T>(type: T.Type) throws -> T where T: Decodable {
        try JSONDecoder().decode(type, from: self)
    }
}
