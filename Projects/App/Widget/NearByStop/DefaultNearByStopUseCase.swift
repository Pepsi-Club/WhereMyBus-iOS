//
//  DefaultNearByStopUseCase.swift
//  Widget
//
//  Created by Jisoo HAM on 4/25/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

import RxSwift

final public class DefaultNearByStopUseCase: NearByStopUseCase {
    private let stationListRepository: StationListRepository
    private let locationService: LocationService
    
    public let nearByStopInfo = PublishSubject<(BusStopInfoResponse, String)>()
    
    private let disposeBag = DisposeBag()
    
    public init(
        stationListRepository: StationListRepository,
        locationService: LocationService
    ) {
        self.stationListRepository = stationListRepository
        self.locationService = locationService
    }
    
    public func updateNearByStop(
    ) -> Observable<(BusStopInfoResponse, String)> {
        locationService.locationStatus
            .withUnretained(self)
            .flatMap { useCase, status in
                print("✅ : \(status) <- locationStatus")
                
                var response: BusStopInfoResponse
                var distanceStr: String
                switch status {
                case .authorized(let location),
                        .alwaysAllowed(let location):
                    (response, distanceStr) = useCase.stationListRepository
                        .getNearByStopInfo(startPointLocation: location)
                    
                    return Observable<(BusStopInfoResponse, String)>
                        .just((response, distanceStr))
                default:
                    return .empty()
                }
                
            }
    }
}
