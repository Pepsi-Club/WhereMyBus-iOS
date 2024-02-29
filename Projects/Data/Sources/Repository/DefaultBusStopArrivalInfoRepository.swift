//
//  DefaultBusStopArrivalInfoRepository.swift
//  Data
//
//  Created by gnksbm on 1/30/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain
import Networks

import RxSwift
import SwiftyXMLParser

public final class DefaultBusStopArrivalInfoRepository:
    NSObject, BusStopArrivalInfoRepository {
    private let networkService: NetworkService
    
    private let disposeBag = DisposeBag()
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func fetchArrivalList(
        busStopId: String,
        busStopName: String
    ) -> Observable<BusStopArrivalInfoResponse> {
        networkService.request(
            endPoint: BusStopArrivalInfoEndPoint(busStopId: busStopId)
        )
        .map { data in
            let xml = XML.parse(data)
            let busStopNum: String? = xml
                .ServiceResult
                .msgBody
                .itemList
                .arsId.text
            
            let busResponses: [BusArrivalInfoResponse?] = xml
                .ServiceResult
                .msgBody
                .itemList
                .map {
                    guard let routeId = $0.busRouteId.text,
                          let routeName = $0.busRouteAbrv.text,
                          let busType = $0.routeType.text,
                          let firstArrivalTime = $0.arrmsg1.text,
                          let secondArrivalTime = $0.arrmsg2.text
                    else {
                        print("Fail to XML Parse")
                        return nil
                    }
                    return BusArrivalInfoResponse(
                        routeId: routeId,
                        isFavorites: false,
                        routeName: routeName,
                        busType: busType,
                        firstArrivalTime: firstArrivalTime,
                        secondArrivalTime: secondArrivalTime,
                        isAlarmOn: false
                    )
                }
            return BusStopArrivalInfoResponse(
                busStopId: busStopId,
                busStopName: busStopName,
                direction: "XX 방면",
                busStopNum: busStopNum,
                buses: busResponses.compactMap { $0 }
            )
        }
    }
}
