//
//  NearMapUseCase.swift
//  Domain
//
//  Created by Muker on 2/7/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol NearBusStopUseCase {
	
	// MARK: - Property
	
	var nearBusStop: PublishSubject<NearBusStopResponse> { get set }
	var selectedBusStop: PublishSubject<NearBusStopResponse> { get set }
	
	// MARK: - Function
	
	func fetchNearBusStop()
	func selectBusStop()
	
}
