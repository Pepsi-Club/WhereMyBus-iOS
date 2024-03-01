//
//  MockFavoritesRepository.swift
//  FeatureDependency
//
//  Created by gnksbm on 3/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

import RxSwift

#if DEBUG
public final class MockFavoritesRepository: FavoritesRepository {
    public var favorites = BehaviorSubject<FavoritesResponse>(
        value: .init(
            busStops: []
        )
    )
    
    public init() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.favorites.onNext(
                .init(
                    busStops: [
                        BusStopArrivalInfoResponse(
                            busStopId: "121000214",
                            busStopName: "길훈아파트",
                            direction: "XX 방면",
                            busStopNum: "02345",
                            buses: [
                                BusArrivalInfoResponse(
                                    routeId: "233000374",
                                    isFavorites: false,
                                    routeName: "P9602퇴",
                                    busType: "1",
                                    firstArrivalTime: "운행종료",
                                    secondArrivalTime: "운행종료",
                                    isAlarmOn: false
                                ),
                                BusArrivalInfoResponse(
                                    routeId: "233000372",
                                    isFavorites: false,
                                    routeName: "P9601퇴",
                                    busType: "1",
                                    firstArrivalTime: "운행종료",
                                    secondArrivalTime: "운행종료",
                                    isAlarmOn: false
                                ),
                                BusArrivalInfoResponse(
                                    routeId: "100100597",
                                    isFavorites: false,
                                    routeName: "405",
                                    busType: "1",
                                    firstArrivalTime: "출발대기",
                                    secondArrivalTime: "출발대기",
                                    isAlarmOn: false
                                ),
                                BusArrivalInfoResponse(
                                    routeId: "208000031",
                                    isFavorites: false,
                                    routeName: "19",
                                    busType: "1",
                                    firstArrivalTime: "운행종료",
                                    secondArrivalTime: "운행종료",
                                    isAlarmOn: false
                                ),
                                BusArrivalInfoResponse(
                                    routeId: "226000022",
                                    isFavorites: false,
                                    routeName: "G3900",
                                    busType: "1",
                                    firstArrivalTime: "출발대기",
                                    secondArrivalTime: "출발대기",
                                    isAlarmOn: false
                                ),
                                BusArrivalInfoResponse(
                                    routeId: "220000012",
                                    isFavorites: false,
                                    routeName: "6",
                                    busType: "1",
                                    firstArrivalTime: "23분28초후[17번째 전]",
                                    secondArrivalTime: "출발대기",
                                    isAlarmOn: false
                                ),
                                BusArrivalInfoResponse(
                                    routeId: "122000001",
                                    isFavorites: false,
                                    routeName: "4435", 
                                    busType: "1",
                                    firstArrivalTime: "곧 도착", 
                                    secondArrivalTime: "34분18초후[14번째 전]",
                                    isAlarmOn: false
                                ),
                                BusArrivalInfoResponse(
                                    routeId: "100100246", isFavorites: false, routeName: "4432", busType: "1", firstArrivalTime: "4분3초후[2번째 전]", secondArrivalTime: "33분51초후[22번째 전]",
                                    isAlarmOn: false
                                ),
                                BusArrivalInfoResponse(
                                    routeId: "122000001", 
                                    isFavorites: false,
                                    routeName: "4435", 
                                    busType: "1",
                                    firstArrivalTime: "운행종료", 
                                    secondArrivalTime: "운행종료",
                                    isAlarmOn: false
                                ),
                                BusArrivalInfoResponse(
                                    routeId: "208000006", 
                                    isFavorites: false,
                                    routeName: "11-3",
                                    busType: "1",
                                    firstArrivalTime: "출발대기",
                                    secondArrivalTime: "출발대기",
                                    isAlarmOn: false
                                ),
                                BusArrivalInfoResponse(
                                    routeId: "208000026",
                                    isFavorites: false,
                                    routeName: "917",
                                    busType: "1",
                                    firstArrivalTime: "출발대기",
                                    secondArrivalTime: "출발대기",
                                    isAlarmOn: false
                                )
                            ])
                    ]
                )
            )
        }
    }
    
    public func addRoute(
        busStopId: String,
        busStopName: String,
        direction: String,
        bus: BusArrivalInfoResponse
    ) {
        
    }
    
    public func removeRoute(
        busStopId: String,
        bus: BusArrivalInfoResponse
    ) {
        
    }
}
#endif
