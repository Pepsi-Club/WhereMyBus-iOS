//
//  AddRegularAlarmDTO.swift
//  Data
//
//  Created by gnksbm on 4/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

struct AddRegularAlarmDTO: Decodable {
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

extension AddRegularAlarmDTO {
    enum CodingKeys: String, CodingKey {
        case alarmId = "id"
    }
}

extension AddRegularAlarmDTO {
    func toDomain(request: AddRegularAlarmRequest) -> RegularAlarmResponse {
        .init(
            requestId: alarmId,
            busStopId: String(request.arsId),
            busStopName: request.busStopName,
            busId: String(request.busRouteId),
            busName: request.busName,
            time: request.time.toDate(dateFormat: "HHmm"),
            weekday: request.weekday,
            adirection: request.adirection
        )
    }
}
