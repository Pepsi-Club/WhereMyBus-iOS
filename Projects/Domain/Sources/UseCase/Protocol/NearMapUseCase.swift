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
    var nearByBusStop: PublishSubject<BusStopInfoResponse> { get }
    
    func getNearByBusStop()
    func getNearBusStopList() -> [BusStopInfoResponse]
    func busStopSelected(busStopId: String)
}
