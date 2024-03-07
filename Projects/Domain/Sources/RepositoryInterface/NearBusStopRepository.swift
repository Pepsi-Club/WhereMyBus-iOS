//
//  NearBusStopRepository.swift
//  Domain
//
//  Created by Muker on 3/5/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol NearBusStopRepository {
	var nearBusStopResponse: BehaviorSubject<NearBusStopResponse> { get set }
}
