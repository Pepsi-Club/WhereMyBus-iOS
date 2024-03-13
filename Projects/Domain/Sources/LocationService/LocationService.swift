//
//  LocationService.swift
//  Domain
//
//  Created by Muker on 3/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation
import CoreLocation

import RxSwift
import RxRelay

public protocol LocationService {
	
	var authState: BehaviorSubject<CLAuthorizationStatus> { get set }
	var currentLocation: BehaviorSubject<CLLocation> { get set }
	
	func requestLocationOnce()
	func startUpdatingLocation()
	func stopUpdatingLocation()
}
