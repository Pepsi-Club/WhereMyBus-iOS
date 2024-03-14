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

public protocol NearBusStopUseCase {
    var stationListRepository: StationListRepository { get }
    var nearByBusStop: PublishSubject<BusStopInfoResponse> { get }
    
    func getNearByBusStop()
    func busStopSelected(busStopId: String)
}
