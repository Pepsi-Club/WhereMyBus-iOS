//
//  DefaultLocationService.swift
//  Data
//
//  Created by Muker on 3/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation
import CoreLocation

import Domain

import RxSwift
import RxCocoa


final public class DefaultLocationService: LocationService {
	
	// MARK: - Property
	
	public var locationManager = CLLocationManager()
	
	//
	public lazy var authorizationStatus = BehaviorRelay<CLAuthorizationStatus>(
		value: locationManager.authorizationStatus
	)
	
	public lazy var currentLocation = BehaviorRelay<CLLocation>(
		value: CLLocation(
			latitude: locationManager.location?.coordinate.latitude ?? 0.0,
			longitude: locationManager.location?.coordinate.longitude ?? 0.0
		)
	)
	
	private let disposeBag = DisposeBag()
	
	// MARK: - Init
	
	public init() { }
	
	// MARK: - Function
	
	public func fetchCurrentLocation() {
		
	}
	
	public func stopCurrentLocation() {
		
	}
	
	public func requestAuthorization() {
		self.locationManager.requestWhenInUseAuthorization()
	}
}
