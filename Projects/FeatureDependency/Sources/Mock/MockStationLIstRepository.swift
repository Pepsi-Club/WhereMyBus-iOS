//
//  MockStationLIstRepository.swift
//  FeatureDependency
//
//  Created by 유하은 on 2024/03/07.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

import RxSwift

#if DEBUG
public final class MockStationLIstRepository: StationListRepository {
    public var searchResponse = BehaviorSubject<[BusStopInfoResponse]>(value: [])
    
    public init(){
        Timer.scheduledTimer(
            withTimeInterval: 3,
            repeats: false
        ) { [weak self] _ in
            self?.searchResponse.onNext(
                [
                    BusStopInfoResponse(
                        busStopName: "관현사입구",
                        busStopId: "22320",
                        direction: "새쟁이마을",
                        longitude: "127.0632387636",
                        latitude: "37.4373210738"
                    ),
                    BusStopInfoResponse(
                        busStopName: "관현사입구",
                        busStopId: "22321",
                        direction: "청계산.원터골",
                        longitude: "127.063704",
                        latitude: "37.437154"
                    ),
                    BusStopInfoResponse(
                        busStopName: "새쟁이마을",
                        busStopId: "22322",
                        direction: "옛골",
                        longitude: "127.066179",
                        latitude: "37.434511"
                    ),
                    BusStopInfoResponse(
                        busStopName: "새쟁이마을",
                        busStopId: "22323",
                        direction: "관현사입구",
                        longitude: "127.0660515509",
                        latitude: "37.4347964213"
                    ),
                    BusStopInfoResponse(
                        busStopName: "옛골",
                        busStopId: "22324",
                        direction: "새쟁이마을",
                        longitude: "127.070438",
                        latitude: "37.430946"
                    ),
                    BusStopInfoResponse(
                        busStopName: "옛골",
                        busStopId: "22341",
                        direction: "청계산옛골",
                        longitude: "127.0707733294",
                        latitude: "37.4305370286"
                    )
                ]
            )
        }
    }
}
#endif
