//
//  RemoveRegularAlarmResponse.swift
//  Domain
//
//  Created by gnksbm on 4/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct RemoveRegularAlarmResponse: Decodable {
    /// 메시지 (ex. 성공, DB Error 등)
    public let message: String
    
    public init(message: String) {
        self.message = message
    }
}
