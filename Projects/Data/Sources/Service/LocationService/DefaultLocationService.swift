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

import RxCocoa
import RxSwift

final public class DefaultLocationService: NSObject, LocationService {
    private let locationManager = CLLocationManager()
    
    public let locationStatus = BehaviorSubject<LocationStatus>(
        value: .notDetermined
    )
    private let disposeBag = DisposeBag()
    
    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    public func authorize() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// 한번의 현재 위치 업데이트
    public func requestLocationOnce() {
        locationManager.requestLocation()
    }
    
    /// 지속적인 현재 위치 업데이트 시작
    public func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    /// 지속적인 현재 위치 업데이트 중지
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    public func getDistance(response: BusStopInfoResponse) -> String {
        let errorMessage = ""
        guard let latitude = Double(response.latitude),
              let longitude = Double(response.longitude)
        else { return errorMessage }
        if let location = locationManager.location {
            let distance = Int(
                location.distance(
                    from: .init(
                        latitude: latitude,
                        longitude: longitude
                    )
                )
            )
            let distanceStr: String
            switch distance {
            case ..<1000:
                distanceStr = "\(distance)m"
            case Int.max:
                distanceStr = "측정거리 초과"
            default:
                distanceStr =  "\(distance / 1000)km"
            }
            return distanceStr
        } else {
            return errorMessage
        }
    }
}
// 앱 오픈 delegate = self
// locationManagerDidChangeAuthorization
extension DefaultLocationService: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        switch manager.authorizationStatus {
        case .notDetermined:
            locationStatus.onNext(.notDetermined)
        case .restricted, .denied:
            locationStatus.onNext(.denied)
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            locationStatus.onNext(.unknown)
        }
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first
        else { return }
        switch manager.authorizationStatus {
        case .authorizedAlways:
            locationStatus.onNext(.alwaysAllowed(location))
        case .authorizedWhenInUse:
            locationStatus.onNext(.authorized(location))
        default:
            break
        }
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        locationStatus.onError(error)
    }
}
