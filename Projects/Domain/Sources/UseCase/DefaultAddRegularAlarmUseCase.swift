//
//  DefaultAddRegularAlarmUseCase.swift
//  Domain
//
//  Created by gnksbm on 2/16/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

import RxSwift

public final class DefaultAddRegularAlarmUseCase: AddRegularAlarmUseCase {
    @Injected private var localNotificationService: LocalNotificationService
    @Injected private var regularAlarmRepository: RegularAlarmRepository
    
    public init() { }
    
    public func checkNotificationAuth() {
        localNotificationService.authorize()
    }
    
    public func addNewAlarm(response: RegularAlarmResponse) {
        regularAlarmRepository.createRegularAlarm(response: response) {
            #if DEBUG
            print("Create Completed")
            #endif
        }
    }
    
    public func editAlarm(response: RegularAlarmResponse) {
        regularAlarmRepository.updateRegularAlarm(response: response) {
            #if DEBUG
            print("Update Completed")
            #endif
        }
    }
}
