//
//  AddRegularAlarmResponse.swift
//  Domain
//
//  Created by gnksbm on 4/4/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct AddRegularAlarmResponse: Decodable {
    /*
    /// 상태코드
    let statusCode: Int
    /// 메시지 (ex. 성공, DB Error 등)
    let message: String
    /// 응답시간
    let timestamp: String
     */
    /// 서버에 등록된 알람 아이디
    public let alarmId: String
    
    public init(alarmId: String) {
        self.alarmId = alarmId
    }
}

public extension AddRegularAlarmResponse {
    var toRemoveRequest: RemoveRegularAlarmRequest {
        .init(alarmId: alarmId)
    }
}

extension AddRegularAlarmResponse {
    enum CodingKeys: String, CodingKey {
//        case statusCode, message, timestamp
        case alarmId = "id"
    }
}
