//
//  MockStationLIstRepository.swift
//  FeatureDependency
//
//  Created by 유하은 on 2024/03/07.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

import RxSwift

#if DEBUG
public final class MockStationLIstRepository: StationListRepository {
    public var searchResponse = BehaviorSubject<[BusStopInfoResponse]>(value: [])
    
    public init(){
        
    }
}
#endif
