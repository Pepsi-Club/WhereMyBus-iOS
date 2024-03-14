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

public final class DefaultNearMapUseCase: NearMapUseCase {
	
	// MARK: - Property
	
	private let stationListRepository: StationListRepository
	
	public var nearBusStop = PublishSubject<NearBusStopResponse>()
	public var selectedBusStop =  PublishSubject<NearBusStopResponse>()
	
	private let disposeBag = DisposeBag()
	
	// MARK: - Life Cycle
	
	public init(
		stationListRepository: StationListRepository
	) {
		self.stationListRepository = stationListRepository
	}
	
	// MARK: - Funtion
	
	public func fetchNearBusStop() {
		
	}
	
	public func selectBusStop() {
		
	}
}
