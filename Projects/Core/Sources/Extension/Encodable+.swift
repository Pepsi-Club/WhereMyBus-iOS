//
//  Encodable+.swift
//  Core
//
//  Created by gnksbm on 2023/12/30.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

public extension Encodable {
    /**
     JSONDecoder로 인코딩
     - Returns: 인코딩 된 Data, 실패 시 nil 반환
     */
    func encode() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
