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
    private var locationManager = CLLocationManager()
    
    public lazy var authState = BehaviorSubject<CLAuthorizationStatus>(
        value: locationManager.authorizationStatus
    )
    
    public lazy var currentLocation = BehaviorSubject<CLLocation>(
        value: .init(
            latitude: 37.570028,
            longitude: 126.979620
        )
    )
    
    private let disposeBag = DisposeBag()
    
    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
        do {
            let currentLocation = try currentLocation.value()
            let distance = Int(
                currentLocation.distance(
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
        } catch {
            return errorMessage
        }
    }
}

extension DefaultLocationService: CLLocationManagerDelegate {
    /// 현재위치가 바뀔때마다 업데이트되는 메서드
    /// locations의 첫번째 인덱스는 최근 위치
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            currentLocation.onNext(location)
        }
    }
    
    /// 위치권한이 바뀔때마다 업데이트되는 메서드
    public func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        authState.onNext(manager.authorizationStatus)
    }
    
    /// 위치 정보 불러오는 도중 에러 처리 메서드
    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        currentLocation.onError(error)
    }
}
