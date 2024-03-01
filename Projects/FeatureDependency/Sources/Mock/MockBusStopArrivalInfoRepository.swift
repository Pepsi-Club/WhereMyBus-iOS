//
//  MockBusStopArrivalInfoRepository.swift
//  FeatureDependency
//
//  Created by gnksbm on 3/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

import RxSwift

#if DEBUG
public final class MockBusStopArrivalInfoRepository
: BusStopArrivalInfoRepository {
    public init() { }
    
    public func fetchArrivalList(
        busStopId: String,
        busStopName: String
    ) -> Observable<BusStopArrivalInfoResponse> {
        .create { observer in
            observer.onNext(
                BusStopArrivalInfoResponse(
                    busStopId: "122000666",
                    busStopName: "강남구보건소",
                    direction: "강남구청역 방면",
                    busStopNum: "23290",
                    buses: [
                        BusArrivalInfoResponse(
                            routeId: "124000038",
                            isFavorites: false,
                            routeName: "342",
                            busType: "3",
                            firstArrivalTime: "7분[3정거장전]",
                            secondArrivalTime: "18분[9정거장전]",
                            isAlarmOn: false),
                        BusArrivalInfoResponse(
                            routeId: "124000039",
                            isFavorites: false,
                            routeName: "3412",
                            busType: "4",
                            firstArrivalTime: "7분[3정거장전]",
                            secondArrivalTime: "18분[9정거장전]",
                            isAlarmOn: false),
                        BusArrivalInfoResponse(
                            routeId: "",
                            isFavorites: false,
                            routeName: "471",
                            busType: "3",
                            firstArrivalTime: "7분[3정거장전]",
                            secondArrivalTime: "18분[9정거장전]",
                            isAlarmOn: false),
                        BusArrivalInfoResponse(
                            routeId: "",
                            isFavorites: false,
                            routeName: "3412",
                            busType: "4",
                            firstArrivalTime: "7분[2정거장전]",
                            secondArrivalTime: "18분[9정거장전]",
                            isAlarmOn: false),
                        BusArrivalInfoResponse(
                            routeId: "",
                            isFavorites: false,
                            routeName: "471",
                            busType: "3",
                            firstArrivalTime: "5분[2정거장전]",
                            secondArrivalTime: "18분[9정거장전]",
                            isAlarmOn: false),
                        BusArrivalInfoResponse(
                            routeId: "",
                            isFavorites: false,
                            routeName: "471",
                            busType: "3",
                            firstArrivalTime: "3분[1정거장전]",
                            secondArrivalTime: "18분[9정거장전]",
                            isAlarmOn: false),
                        BusArrivalInfoResponse(
                            routeId: "",
                            isFavorites: false,
                            routeName: "541",
                            busType: "3",
                            firstArrivalTime: "7분[3정거장전]",
                            secondArrivalTime: "18분[9정거장전]",
                            isAlarmOn: false),
                        BusArrivalInfoResponse(
                            routeId: "",
                            isFavorites: false,
                            routeName: "4001-1",
                            busType: "1",
                            firstArrivalTime: "18분[2정거장전]",
                            secondArrivalTime: "35분[3정거장전]",
                            isAlarmOn: false),
                    ]
                )
            )
            return Disposables.create()
        }
    }
}
#endif
