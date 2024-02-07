//
//  DefaultBusStopUseCase.swift
//  Domain
//
//  Created by Jisoo HAM on 2/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

public final class DefaultBusStopUseCase: BusStopUseCase {
    public let busStopSection = PublishSubject<[BusStopArrivalInfoResponse]>()
    private let disposeBag = DisposeBag()
    
    // mock data
    var sections = [
        BusStopArrivalInfoResponse(
            busStopId: "23290",
            busStopName: "강남구보건소",
            direction: "강남구청역 방면",
            buses: [
                BusArrivalInfoResponse(
                    routeId: "",
                    isFavorites: false,
                    routeName: "342",
                    busType: "0",
                    firstArrivalTime: "7분[3정거장전]",
                    secondArrivalTime: "18분[9정거장전]",
                    isAlarmOn: false),
                BusArrivalInfoResponse(
                    routeId: "",
                    isFavorites: false,
                    routeName: "3412",
                    busType: "1",
                    firstArrivalTime: "7분[3정거장전]",
                    secondArrivalTime: "18분[9정거장전]",
                    isAlarmOn: false),
                BusArrivalInfoResponse(
                    routeId: "",
                    isFavorites: false,
                    routeName: "471",
                    busType: "1",
                    firstArrivalTime: "7분[3정거장전]",
                    secondArrivalTime: "18분[9정거장전]",
                    isAlarmOn: false),
                BusArrivalInfoResponse(
                    routeId: "",
                    isFavorites: false,
                    routeName: "3412",
                    busType: "0",
                    firstArrivalTime: "7분[3정거장전]",
                    secondArrivalTime: "18분[9정거장전]",
                    isAlarmOn: false),
                BusArrivalInfoResponse(
                    routeId: "",
                    isFavorites: false,
                    routeName: "471",
                    busType: "0",
                    firstArrivalTime: "7분[3정거장전]",
                    secondArrivalTime: "18분[9정거장전]",
                    isAlarmOn: false),
                BusArrivalInfoResponse(
                    routeId: "",
                    isFavorites: false,
                    routeName: "471",
                    busType: "2",
                    firstArrivalTime: "7분[3정거장전]",
                    secondArrivalTime: "18분[9정거장전]",
                    isAlarmOn: false),
                BusArrivalInfoResponse(
                    routeId: "",
                    isFavorites: false,
                    routeName: "541",
                    busType: "2",
                    firstArrivalTime: "7분[3정거장전]",
                    secondArrivalTime: "18분[9정거장전]",
                    isAlarmOn: false),
            ]
        )
    ]
    
    public init() {
        fetchBusArrivals()
    }
    
    public func fetchBusArrivals() {
        busStopSection
            .onNext(sections)
    }
    
    // TODO: 즐겨찾기 추가 logic
}
