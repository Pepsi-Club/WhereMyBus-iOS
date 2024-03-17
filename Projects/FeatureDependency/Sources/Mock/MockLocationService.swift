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
	
	
    public let authState = BehaviorSubject<CLAuthorizationStatus>(
        value: .notDetermined
    )
    
    public let currentLocation = BehaviorSubject<CLLocation>(value: .init())
    
    public init() { }

    public func authorize() {
        
    }
	
    public func requestLocationOnce(completion: (() -> Void)?) {
        
    }
    
    public func startUpdatingLocation() {
        
    }
    
    public func stopUpdatingLocation() {
        
    }
}
#endif
