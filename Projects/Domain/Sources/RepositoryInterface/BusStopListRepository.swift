//
//  BusStopListRepository.swift
//  Domain
//
//  Created by gnksbm on 1/28/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol BusStopListRepository {
    var busStopInfoResponse: BehaviorSubject<[BusStopInfoResponse]> { get }
}
