//
//  NearMapUseCase.swift
//  Domain
//
//  Created by Muker on 2/7/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import CoreLocation
import Foundation

import RxSwift

public protocol NearMapUseCase {
    var nearBusStopList: PublishSubject<[BusStopInfoResponse]> { get }
    var nearByBusStop: PublishSubject<BusStopInfoResponse> { get }
    
    func updateNearByBusStop()
    func updateNearBusStopList(
        longitudeRange: ClosedRange<Double>,
        latitudeRange: ClosedRange<Double>
    )
    func busStopSelected(busStopId: String)
}
