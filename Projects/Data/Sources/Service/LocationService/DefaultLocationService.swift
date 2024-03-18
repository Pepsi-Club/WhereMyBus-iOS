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
        value: CLLocation(
            latitude: 37.571314,
            longitude: 126.987886
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
        authState
            .subscribe(
                onNext: { print(String(describing: $0)) }
            )
            .disposed(by: disposeBag)
    }
    
    /// 한번의 현재 위치 업데이트
    /// completion: 위치 업데이트가 끝나고 실행할 함수를 정의하기 위함
    public func requestLocationOnce(
        completion: (() -> Void)?
    ) {
        locationManager.requestLocation()
        completion?()
    }
    
    /// 지속적인 현재 위치 업데이트 시작
    public func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    /// 지속적인 현재 위치 업데이트 중지
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
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
        
#if DEBUG
        print("📍 현재 좌표 : \(locations[0])")
#endif
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