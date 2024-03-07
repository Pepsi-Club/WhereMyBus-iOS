//
//  LocationService.swift
//  NearMapFeatureDemo
//
//  Created by Muker on 3/7/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import CoreLocation
import Foundation

import RxSwift
import RxRelay

protocol LocationService {
	var authorizationStatus: BehaviorRelay<CLAuthorizationStatus> { get set }
	func start()
	func stop()
	func requestAuthorization()
	func observeUpdatedAuthorization() -> Observable<CLAuthorizationStatus>
	func observeUpdatedLocation() -> Observable<[CLLocation]>
}
