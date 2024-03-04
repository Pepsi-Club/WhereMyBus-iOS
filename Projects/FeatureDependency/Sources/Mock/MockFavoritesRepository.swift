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
    public var favorites = BehaviorSubject<[FavoritesBusStopResponse]>(
        value: []
    )
    
    public init() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.favorites.onNext(
                [
                    BusStopArrivalInfoResponse(
                        busStopId: "23290",
                        busStopName: "강남구보건소",
                        direction: "강남구청역",
                        buses: [
                            BusArrivalInfoResponse(
                                busId: "124000038",
                                busName: "342",
                                busType: BusType.trunkLine.rawValue,
                                nextStation: "강남구청역",
                                firstArrivalTime: "3분29초후",
                                firstArrivalRemaining: "2번째 전",
                                secondArrivalTime: "17분9초후",
                                secondArrivalRemaining: "6번째 전",
                                isFavorites: false,
                                isAlarmOn: false
                            ),
                            BusArrivalInfoResponse(
                                busId: "100100075",
                                busName: "472",
                                busType: BusType.trunkLine.rawValue,
                                nextStation: "강남구청역",
                                firstArrivalTime: "3분1초후",
                                firstArrivalRemaining: "1번째 전",
                                secondArrivalTime: "6분52초후",
                                secondArrivalRemaining: "3번째 전",
                                isFavorites: false,
                                isAlarmOn: false
                            ),
                            BusArrivalInfoResponse(
                                busId: "100100226",
                                busName: "3414",
                                busType: BusType.branchLine.rawValue,
                                nextStation: "삼성동서광아파트",
                                firstArrivalTime: "2분46초후",
                                firstArrivalRemaining: "1번째 전",
                                secondArrivalTime: "9분38초후",
                                secondArrivalRemaining: "5번째 전",
                                isFavorites: false,
                                isAlarmOn: false
                            ),
                            BusArrivalInfoResponse(
                                busId: "100100612",
                                busName: "3426",
                                busType: BusType.branchLine.rawValue,
                                nextStation: "삼성동서광아파트",
                                firstArrivalTime: "7분33초후",
                                firstArrivalRemaining: "4번째 전",
                                secondArrivalTime: "15분29초후",
                                secondArrivalRemaining: "7번째 전",
                                isFavorites: false,
                                isAlarmOn: false
                            ),
                            BusArrivalInfoResponse(
                                busId: "100100500",
                                busName: "4312",
                                busType: BusType.branchLine.rawValue,
                                nextStation: "강남구청역",
                                firstArrivalTime: "5분3초후",
                                firstArrivalRemaining: "3번째 전",
                                secondArrivalTime: "13분36초후",
                                secondArrivalRemaining: "8번째 전",
                                isFavorites: false,
                                isAlarmOn: false
                            )]
                    )
                ].map {
                    .init(
                        busStopId: $0.busStopId,
                        busIds: $0.buses.map({ $0.busId })
                    )
                }
            )
        }
    }
    
    public func addRoute(
        arsId: String,
        bus: BusArrivalInfoResponse
    ) {
        
    }
    
    public func removeRoute(
        arsId: String,
        bus: BusArrivalInfoResponse
    ) {
        
    }
}
#endif
