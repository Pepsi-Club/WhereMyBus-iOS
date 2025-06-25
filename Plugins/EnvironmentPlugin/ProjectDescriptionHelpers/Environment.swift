//
//  Environment.swift
//  Environment
//
//  Created by gnksbm on 2023/11/19.
//

import Foundation
import ProjectDescription

public extension String {
    static let appName: Self = "WhereMyBus"
    static let displayName: Self = "버스어디"
    static let organizationName = "Pepsi-Club"
    static let teamId = "T4W7695R5C"
    static let targetVersion: Self = "16.0"
    static let bundleID: Self = "com.\(organizationName).\(appName)"
    /// 앱스토어에 게시할 때마다 증가해줘야 하는 버전
    static let marketingVersion: Self = "1.3.0"
    /// 개발자가 내부적으로 확인하기 위한 용도 (날짜를 사용하기도 함 - 2023.12.8.1 )
    static var buildVersion: Self {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd.HH.mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: date)
    }
}
