//
//  DefaultNearBusStopRepository.swift
//  Data
//
//  Created by Muker on 3/5/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation
import CoreLocation

import Domain

import RxSwift

public final class DefaultNearBusStopRepository: NearBusStopRepository {
	
	
	// MARK: - Property
	
	// 가장 가까운 정류장 하나
	public var nearBusStopResponse = BehaviorSubject<NearBusStopResponse>(
		value: NearBusStopResponse.mockBusStop
	)
	
	private let disposeBag = DisposeBag()
	
	// MARK: - Life Cycle
	
	public init() { 
		fetchBusStopResponse()
	}
	
	// MARK: - Function
	
	public func fetchBusStopResponse() {
		
	}
	
}
