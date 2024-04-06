//
//  AddRegularAlarmRequest.swift
//  Domain
//
//  Created by gnksbm on 4/4/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

public struct AddRegularAlarmRequest {
    // MARK: 서버 요청값
    /// 알람받을시간 ex) "1830"
    public let time: String
    /// 0 ~ 6 : 일, 월, 화, 수, 목, 금, 토 순서
    public let activeDay: [Int]
    /// 버스코드
    public let busRouteId: String
    /// 정류장코드
    public let arsId: String
    // MARK: 로컬에서 필요한 데이터
    public let busStopName: String
    public let busName: String
    
    public init(
        date: Date,
        activeDay: [Int],
        busRouteId: String,
        arsId: String,
        busStopName: String,
        busName: String
    ) {
        self.time = date.toString(dateFormat: "HHmm")
        self.activeDay = activeDay
        self.busRouteId = busRouteId
        self.arsId = arsId
        self.busStopName = busStopName
        self.busName = busName
    }
}
