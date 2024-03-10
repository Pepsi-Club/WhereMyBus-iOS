//
//  DefaultRegularAlarmUseCase.swift
//  Domain
//
//  Created by gnksbm on 3/10/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public class DefaultRegularAlarmUseCase: RegularAlarmUseCase {
    private let localNotificationService: LocalNotificationService
    
    public let fetchedAlarm = PublishSubject<[RegularAlarmResponse]>()
    private let disposeBag = DisposeBag()
    
    public init(localNotificationService: LocalNotificationService) {
        self.localNotificationService = localNotificationService
    }
    
    public func fetchAlarm() {
        localNotificationService.fetchRegularAlarm()
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, responses in
                    useCase.fetchedAlarm.onNext(responses)
                }
            )
            .disposed(by: disposeBag)
    }
    
    public func removeAlarm(response: RegularAlarmResponse) throws {
        do {
            try localNotificationService.removeRegularAlarm(response: response)
            fetchAlarm()
        } catch {
            throw error
        }
    }
}
