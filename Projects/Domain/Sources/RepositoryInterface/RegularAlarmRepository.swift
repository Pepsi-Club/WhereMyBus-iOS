//
//  RegularAlarmRepository.swift
//  Domain
//
//  Created by gnksbm on 4/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol RegularAlarmRepository {
    @available(*, deprecated, message: "이 변수는 제거될 예정입니다.")
    var currentRegularAlarm: BehaviorSubject<[RegularAlarmResponse]> { get }
    
    @available(*, deprecated, message: "이 메서드는 제거될 예정입니다.")
    func createRegularAlarm(
        response: RegularAlarmResponse,
        completion: @escaping () -> Void
    )
    @available(*, deprecated, message: "이 메서드는 제거될 예정입니다.")
    func updateRegularAlarm(
        response: RegularAlarmResponse,
        completion: @escaping () -> Void
    )
    @available(*, deprecated, message: "이 메서드는 제거될 예정입니다.")
    func deleteRegularAlarm(
        response: RegularAlarmResponse,
        completion: @escaping () -> Void
    )
}
