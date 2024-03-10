//
//  MockLocalNotificationService.swift
//  FeatureDependency
//
//  Created by gnksbm on 3/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation
import NotificationCenter

import Domain

import RxSwift

#if DEBUG
public final class MockLocalNotificationService: LocalNotificationService {
    
    public var authState = BehaviorSubject<UNAuthorizationStatus>(
        value: .denied
    )
    
    public init() { }
    
    public func authorize() {
    }
    
    public func fetchRegularAlarm() -> Observable<[RegularAlarmResponse]> {
        .just([])
    }
    
    public func registNewRegularAlarm(response: Domain.RegularAlarmResponse) throws {
        
    }
    
    public func editRegularAlarm(response: Domain.RegularAlarmResponse) throws {
        
    }
    
    public func removeRegularAlarm(response: Domain.RegularAlarmResponse) throws {
        
    }
}
#endif
