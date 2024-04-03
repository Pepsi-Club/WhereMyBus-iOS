//
//  MockLocationService.swift
//  FeatureDependency
//
//  Created by gnksbm on 3/15/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import CoreLocation
import Foundation

import Domain

import RxSwift

#if DEBUG
public final class MockLocationService: LocationService {
    public var locationStatus = BehaviorSubject<LocationStatus>(
        value: .notDetermined
    )
    
    public init() { }

    public func authorize() {
        
    }
	
    public func requestLocationOnce() {
        
    }
    
    public func startUpdatingLocation() {
        
    }
    
    public func stopUpdatingLocation() {
        
    }
    
    public func getDistance(response: Domain.BusStopInfoResponse) -> String {
        ""
    }
}
#endif
