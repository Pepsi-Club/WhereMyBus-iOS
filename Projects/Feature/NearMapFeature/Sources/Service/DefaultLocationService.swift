//
//  DefaultLocationService.swift
//  NearMapFeatureDemo
//
//  Created by Muker on 3/7/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import CoreLocation
import Foundation

import RxRelay
import RxSwift

//final public class DefaultLocationService: NSObject, LocationService {
//	
//	// MARK: - Property
//	
//	public var locationManager: CLLocationManager?
//	public var locationCoordinate2D: CLLocationCoordinate2D?
//	public var authorizationStatus = BehaviorRelay<CLAuthorizationStatus>(
//		value: .notDetermined
//	)
//	private var disposeBag = DisposeBag()
//	
//	// MARK: - Life Cycle
//	
//	override init() {
//		super.init()
//		self.locationManager = CLLocationManager()
//		self.locationManager?.distanceFilter = CLLocationDistance(3)
//		self.locationManager?.delegate = self
//		self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//	}
//	
//	func start() {
//		self.locationManager?.startUpdatingLocation()
//	}
//	
//	func stop() {
//		self.locationManager?.stopUpdatingLocation()
//	}
//	
//	func requestAuthorization() {
//		self.locationManager?.requestWhenInUseAuthorization()
//	}
//	
//	func observeUpdatedAuthorization(
//	) -> RxSwift.Observable<CLAuthorizationStatus> {
//		return self.authorizationStatus.asObservable()
//	}
//	
//	func observeUpdatedLocation() -> RxSwift.Observable<[CLLocation]> {
//		return PublishRelay<[CLLocation]>.create({ emitter in
//			self.rx.methodInvoked(
//				#selector(
//					CLLocationManagerDelegate.locationManager(
//						_:didUpdateLocations:
//					)
//				)
//			)
//			.compactMap({ $0.last as? [CLLocation] })
//			.subscribe(onNext: { location in
//				emitter.onNext(location)
//			})
//			.disposed(by: self.disposeBag)
//			return Disposables.create()
//		})
//	}
//	
//	// MARK: - todo: 임시 좌표 거리구하기
//	
//	func getBetweenDistance(
//		latitude: Double,
//		longitude: Double
//	) {
//		
//		let fromLocation = CLLocationCoordinate2D(
//			latitude: latitude,
//			longitude: longitude
//		)
//		
//		let distane = locationCoordinate2D?.distance(from: fromLocation)
//		
//	}
//
//}
//
//extension DefaultLocationService: CLLocationManagerDelegate {
//	
//	public func locationManager(
//		_ manager: CLLocationManager,
//		didUpdateLocations locations: [CLLocation]
//	) {
//		
//	}
//	
//	public func locationManager(
//		_ manager: CLLocationManager,
//		didChangeAuthorization status: CLAuthorizationStatus
//	) {
//		self.authorizationStatus.accept(status)
//	}
//}
//
//extension CLLocationCoordinate2D {
//	
//	func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
//		
//		let from = CLLocation(
//			latitude: from.latitude,
//			longitude: from.longitude
//		)
//		
//		let too = CLLocation(
//			latitude: 37.61653,
//			longitude: 126.718706
//		)
//		
//		return from.distance(from: too)
//	}
//}
