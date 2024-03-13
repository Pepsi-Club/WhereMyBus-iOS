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
	var authorizationStatus: BehaviorRelay<CLAuthorizationStatus> { get set }
	var currentLocation: BehaviorRelay<CLLocation> { get set }
	
	/// 위치정보 수준 받기
	func requestAuthorization()
	/// 현재 위치 받기
	func fetchCurrentLocation()
	/// 현재 위치 받는거 멈추기
	func stopCurrentLocation()
}
