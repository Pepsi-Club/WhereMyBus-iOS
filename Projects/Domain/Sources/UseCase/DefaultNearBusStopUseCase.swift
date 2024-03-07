//
//  NearMapUseCase.swift
//  Domain
//
//  Created by Muker on 2/14/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import CoreLocation
import Foundation

import RxSwift
import RxCocoa

public final class DefaultNearBusStopUseCase: NearBusStopUseCase {
	
	// MARK: - DI Property
	
	private let nearMapUseCase: NearBusStopRepository
//	private let locationService: LocationService
	
	// MARK: - Life Cycle
	
	init(nearMapUseCase: NearBusStopRepository) {
		self.nearMapUseCase = nearMapUseCase
	}
}
