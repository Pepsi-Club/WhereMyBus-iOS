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

final class DefaultNearByStopUseCase: NearByStopUseCase {
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
            .map { useCase, status in
                print("✅ : \(status) <- locationStatus")
                
                var response: BusStopInfoResponse
                var distanceStr: String
                let requestMessage = "확인하려면 위치사용을 허용해주세요"
                let waitingMessage = "위치 정보 가져오는 중..."
                let errorMessage = "위치 정보를 가져올 수 없습니다"
                switch status {
                case .authorized(let location),
                        .alwaysAllowed(let location):
                    (response, distanceStr) = useCase.stationListRepository
                        .getNearByStopInfo(startPointLocation: location)
                case .waitingForLocation:
                    response = .init(
                        busStopName: waitingMessage,
                        busStopId: "",
                        direction: "",
                        longitude: "126.979620",
                        latitude: "37.570028"
                    )
                    distanceStr = ""
                case .notDetermined, .denied:
                    response = .init(
                        busStopName: requestMessage,
                        busStopId: "",
                        direction: "",
                        longitude: "126.979620",
                        latitude: "37.570028"
                    )
                    distanceStr = ""
                case .error:
                    response = .init(
                        busStopName: errorMessage,
                        busStopId: "",
                        direction: "",
                        longitude: "126.979620",
                        latitude: "37.570028"
                    )
                    distanceStr = ""
                }
                return (response, distanceStr)
            }
    }
}
