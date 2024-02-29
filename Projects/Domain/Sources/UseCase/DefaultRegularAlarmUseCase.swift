//
//  DefaultRegularAlarmUseCase.swift
//  Domain
//
//  Created by gnksbm on 2/16/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public final class DefaultRegularAlarmUseCase: RegularAlarmUseCase {
    private let regularAlarmRepository: RegularAlarmRepository
    private let localNotificationService: LocalNotificationService
    
    public init(
        regularAlarmRepository: RegularAlarmRepository,
        localNotificationService: LocalNotificationService
    ) {
        self.regularAlarmRepository = regularAlarmRepository
        self.localNotificationService = localNotificationService
    }
    
    public func checkNotificationAuth() {
        localNotificationService.authorize()
        localNotificationService.fetchRegularAlarm()
    }
    
    public func addNewAlarm(response: RegularAlarmResponse) {
        do {
            try localNotificationService.registNewRegularAlarm(
                response: response
            )
            try regularAlarmRepository.addNewAlarm()
        } catch {
            print(error)
        }
    }
}
