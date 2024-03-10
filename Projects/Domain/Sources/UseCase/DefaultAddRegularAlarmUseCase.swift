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
    }
    
    public func fetchAlarm() -> Observable<[RegularAlarmResponse]> {
        localNotificationService.fetchRegularAlarm()
    }
    
    public func addNewAlarm(response: RegularAlarmResponse) {
        do {
            try localNotificationService.registNewRegularAlarm(
                response: response
            )
            try regularAlarmRepository.addNewAlarm()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func editAlarm(response: RegularAlarmResponse) {
        do {
            try localNotificationService.editRegularAlarm(response: response)
        } catch {
            print(error.localizedDescription)
        }
    }
}
