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
	
	// MARK: - Property
	
	private let nearMapUseCase: NearBusStopRepository
	
	public var nearBusStop = PublishSubject<NearBusStopResponse>()
	public var selectedBusStop =  PublishSubject<NearBusStopResponse>()
	
	private let disposeBag = DisposeBag()
	
	// MARK: - Life Cycle
	
	public init(nearMapUseCase: NearBusStopRepository) {
		self.nearMapUseCase = nearMapUseCase
	}
	
	// MARK: - Funtion
	
	public func fetchNearBusStop() {
		
	}
	
	public func selectBusStop() {
		
	}
}
