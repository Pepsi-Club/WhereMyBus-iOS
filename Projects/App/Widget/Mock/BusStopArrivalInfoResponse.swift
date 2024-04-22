//
//  MockData.swift
//  WidgetExtension
//
//  Created by gnksbm on 4/7/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

#if DEBUG
extension [BusStopArrivalInfoResponse] {
    static let mock = [
        BusStopArrivalInfoResponse(
            busStopId: "03192",
            busStopName: "서울특별시어린이병원.강동송파과학화예비군훈련장",
            direction: "이태원역1번출구.해밀턴호텔",
            buses: [
                BusArrivalInfoResponse(
                    busId: "100100016",
                    busName: "110A고려대",
                    busType: BusType.trunkLine.rawValue,
                    nextStation: "이태원역1번출구.해밀턴호텔",
                    firstArrivalState: ArrivalState.arrivalTime(time: 182),
                    firstArrivalRemaining: "1번째 전",
                    secondArrivalState: ArrivalState.arrivalTime(time: 896),
                    secondArrivalRemaining: "8번째 전",
                    adirection: "",
                    isFavorites: false,
                    isAlarmOn: false
                ),
                BusArrivalInfoResponse(
                    busId: "111900011",
                    busName: "은평08-1",
                    busType: BusType.village.rawValue,
                    nextStation: "힐스테이트116동앞",
                    firstArrivalState: ArrivalState.pending,
                    firstArrivalRemaining: "",
                    secondArrivalState: ArrivalState.pending,
                    secondArrivalRemaining: "",
                    adirection: "",
                    isFavorites: false,
                    isAlarmOn: false
                ),
                BusArrivalInfoResponse(
                    busId: "111900012",
                    busName: "은평08-2",
                    busType: BusType.village.rawValue,
                    nextStation: "힐스테이트116동앞",
                    firstArrivalState: ArrivalState.pending,
                    firstArrivalRemaining: "",
                    secondArrivalState: ArrivalState.pending,
                    secondArrivalRemaining: "",
                    adirection: "",
                    isFavorites: false,
                    isAlarmOn: false
                )
            ]
        ),
        BusStopArrivalInfoResponse(
            busStopId: "21247",
            busStopName: "벽산블루밍벽산아파트303동앞",
            direction: "벽산아파트.적십자남부봉사관",
            buses: [
                BusArrivalInfoResponse(
                    busId: "100100251",
                    busName: "5513",
                    busType: BusType.branchLine.rawValue,
                    nextStation: "벽산아파트.적십자남부봉사관",
                    firstArrivalState: ArrivalState.arrivalTime(time: 154),
                    firstArrivalRemaining: "2번째 전",
                    secondArrivalState: ArrivalState.arrivalTime(time: 633),
                    secondArrivalRemaining: "8번째 전",
                    adirection: "",
                    isFavorites: false,
                    isAlarmOn: false
                ),
                BusArrivalInfoResponse(
                    busId: "100100596",
                    busName: "400",
                    busType: BusType.trunkLine.rawValue,
                    nextStation: "이태원역.보광동입구",
                    firstArrivalState: ArrivalState.arrivalTime(time: 251),
                    firstArrivalRemaining: "2번째 전",
                    secondArrivalState: ArrivalState.arrivalTime(time: 803),
                    secondArrivalRemaining: "막차",
                    adirection: "",
                    isFavorites: false,
                    isAlarmOn: false
                ),
                BusArrivalInfoResponse(
                    busId: "100100597",
                    busName: "405",
                    busType: BusType.trunkLine.rawValue,
                    nextStation: "이태원역.보광동입구",
                    firstArrivalState: ArrivalState.arrivalTime(time: 627),
                    firstArrivalRemaining: "6번째 전",
                    secondArrivalState: ArrivalState.arrivalTime(time: 1091),
                    secondArrivalRemaining: "11번째 전",
                    adirection: "",
                    isFavorites: false,
                    isAlarmOn: false
                ),
                BusArrivalInfoResponse(
                    busId: "104000011",
                    busName: "N31",
                    busType: BusType.trunkLine.rawValue,
                    nextStation: "이태원역1번출구.해밀턴호텔",
                    firstArrivalState: ArrivalState.finished,
                    firstArrivalRemaining: "",
                    secondArrivalState: ArrivalState.finished,
                    secondArrivalRemaining: "",
                    adirection: "",
                    isFavorites: false,
                    isAlarmOn: false
                ),
                BusArrivalInfoResponse(
                    busId: "111000017",
                    busName: "N72",
                    busType: BusType.trunkLine.rawValue,
                    nextStation: "이태원역1번출구.해밀턴호텔",
                    firstArrivalState: ArrivalState.finished,
                    firstArrivalRemaining: "",
                    secondArrivalState: ArrivalState.finished,
                    secondArrivalRemaining: "",
                    adirection: "",
                    isFavorites: false,
                    isAlarmOn: false
                )
            ]
        ),
        BusStopArrivalInfoResponse(
            busStopId: "12811",
            busStopName: "힐스테이트302동앞",
            direction: "힐스테이트116동앞",
            buses: [
                BusArrivalInfoResponse(
                    busId: "111900005",
                    busName: "은평05",
                    busType: BusType.village.rawValue,
                    nextStation: "힐스테이트116동앞",
                    firstArrivalState: ArrivalState.pending,
                    firstArrivalRemaining: "",
                    secondArrivalState: ArrivalState.pending,
                    secondArrivalRemaining: "",
                    adirection: "",
                    isFavorites: false,
                    isAlarmOn: false
                ),
                BusArrivalInfoResponse(
                    busId: "116900012",
                    busName: "구로06",
                    busType: BusType.village.rawValue,
                    nextStation: "고척공구상가",
                    firstArrivalState: ArrivalState.pending,
                    firstArrivalRemaining: "",
                    secondArrivalState: ArrivalState.pending,
                    secondArrivalRemaining: "",
                    adirection: "",
                    isFavorites: false,
                    isAlarmOn: false
                )
            ]
        ),
        BusStopArrivalInfoResponse(
            busStopId: "17486",
            busStopName: "123전자타운.2001아울렛",
            direction: "고척공구상가",
            buses: [
                BusArrivalInfoResponse(
                    busId: "116900009",
                    busName: "구로05",
                    busType: BusType.village.rawValue,
                    nextStation: "고척공구상가",
                    firstArrivalState: ArrivalState.arrivalTime(time: 330),
                    firstArrivalRemaining: "0번째 전",
                    secondArrivalState: ArrivalState.arrivalTime(time: 915),
                    secondArrivalRemaining: "4번째 전",
                    adirection: "",
                    isFavorites: false,
                    isAlarmOn: false
                )
            ]
        )
    ]
}
#endif
