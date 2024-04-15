//
//  RemoveRegularAlarmRequest.swift
//  Domain
//
//  Created by gnksbm on 4/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct RemoveRegularAlarmRequest {
    /// 서버에 등록된 알람 아이디
    public let alarmId: String
    
    public init(alarmId: String) {
        self.alarmId = alarmId
    }
}
