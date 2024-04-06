//
//  DefaultAddRegularAlarmUseCase.swift
//  Domain
//
//  Created by gnksbm on 2/16/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public final class DefaultAddRegularAlarmUseCase: AddRegularAlarmUseCase {
    private let localNotificationService: LocalNotificationService
    private let regularAlarmRepository: RegularAlarmRepository
    
    public init(
        localNotificationService: LocalNotificationService,
        regularAlarmRepository: RegularAlarmRepository
    ) {
        self.localNotificationService = localNotificationService
        self.regularAlarmRepository = regularAlarmRepository
    }
    
    public func checkNotificationAuth() {
        localNotificationService.authorize()
    }
    
    public func addNewAlarm(response: RegularAlarmResponse) {
        regularAlarmRepository.createRegularAlarm(response: response) {
            print("Create Completed")
        }
    }
    
    public func editAlarm(response: RegularAlarmResponse) {
        regularAlarmRepository.updateRegularAlarm(response: response) {
            print("Update Completed")
        }
    }
}
