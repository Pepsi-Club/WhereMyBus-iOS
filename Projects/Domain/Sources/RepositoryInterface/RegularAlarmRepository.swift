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
    var currentRegularAlarm: BehaviorSubject<[RegularAlarmResponse]> { get }
    
    func createRegularAlarm(
        response: RegularAlarmResponse,
        completion: @escaping () -> Void
    )
    func updateRegularAlarm(response: RegularAlarmResponse)
    func deleteRegularAlarm(
        response: RegularAlarmResponse,
        completion: @escaping () -> Void
    )
}
