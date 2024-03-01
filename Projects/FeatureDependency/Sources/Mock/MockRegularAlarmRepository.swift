//
//  MockRegularAlarmRepository.swift
//  FeatureDependency
//
//  Created by gnksbm on 3/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

import RxSwift

#if DEBUG
public final class MockRegularAlarmRepository: RegularAlarmRepository {
    public init() { }
    
    public func addNewAlarm() throws {
        
    }
}
#endif
