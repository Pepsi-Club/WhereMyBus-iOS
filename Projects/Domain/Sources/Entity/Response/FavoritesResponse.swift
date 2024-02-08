//
//  FavoritesResponse.swift
//  Domain
//
//  Created by gnksbm on 1/30/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct FavoritesResponse: Codable {
    public let busStops: [BusStopArrivalInfoResponse]
    
    public init(busStops: [BusStopArrivalInfoResponse]) {
        self.busStops = busStops
    }
}

extension FavoritesResponse {
    public func addRoute(
        busStopId: String,
        busStopName: String,
        direction: String,
        bus: BusArrivalInfoResponse
    ) -> Self {
        if busStops.hasBusStop(busStopId: busStopId) {
            var newbusStops = busStops
            guard let stationIndex = newbusStops.firstIndex(
                where: { station in
                    station.busStopId == busStopId
                }
            )
            else { return .init(busStops: newbusStops) }
            newbusStops[stationIndex].buses = newbusStops[stationIndex].buses
                .filter { $0 != bus }
            return .init(busStops: newbusStops)
        } else {
            return self
        }
    }
    
    public func removeRoute(
        busStopId: String,
        bus: BusArrivalInfoResponse
    ) -> Self {
        if busStops.hasBusStop(busStopId: busStopId) {
            var newStations = busStops
            guard let stationIndex = newStations.firstIndex(
                where: { station in
                    station.busStopId == busStopId
                }
            )
            else { return .init(busStops: newStations) }
            newStations[stationIndex].buses.append(bus)
            return .init(busStops: newStations)
        } else {
            return self
        }
    }
}

public struct BusStopArrivalInfoResponse: Codable, Hashable {
    public let busStopId: String
    public let busStopName: String
    public let direction: String
    public var buses: [BusArrivalInfoResponse]
    
    public init(
        busStopId: String,
        busStopName: String,
        direction: String,
        buses: [BusArrivalInfoResponse]
    ) {
        self.busStopId = busStopId
        self.busStopName = busStopName
        self.direction = direction
        self.buses = buses
    }
}

extension Array<BusStopArrivalInfoResponse> {
    public var toSection: [FavoritesSection] {
        map { element in
                .init(
                    busStopName: element.busStopName,
                    busStopDirection: "XX 방면",
                    items: element.buses.map { bus in
                        let splittedMsg1 = bus.firstArrivalTime
                            .split(separator: "[")
                            .map { String($0) }
                        let splittedMsg2 = bus.secondArrivalTime
                            .split(separator: "[")
                            .map { String($0) }
                        let firstArrivalTime = splittedMsg1[0]
                        let secondArrivalTime = splittedMsg2[0]
                        var firstArrivalRemaining = ""
                        var secondArrivalRemaining = ""
                        if splittedMsg1.count > 1 {
                            firstArrivalRemaining = splittedMsg1[1]
                            firstArrivalRemaining.removeLast()
                        }
                        if splittedMsg2.count > 1 {
                            secondArrivalRemaining = splittedMsg2[1]
                            secondArrivalRemaining.removeLast()
                        }
                        return .init(
                            routeName: bus.routeName,
                            firstArrivalTime: firstArrivalTime,
                            firstArrivalRemaining: firstArrivalRemaining,
                            secondArrivalTime: secondArrivalTime,
                            secondArrivalRemaining: secondArrivalRemaining
                        )
                    }
                )
        }
    }
    
    func hasBusStop(busStopId: String) -> Bool {
        contains { station in
            station.busStopId == busStopId
        }
    }
}

public struct BusArrivalInfoResponse: Codable, Hashable {
    public let routeId: String
    public var isFavorites: Bool
    public let routeName: String
    public let busType: BusType
    public let firstArrivalTime: String
    public let secondArrivalTime: String
    public var isAlarmOn: Bool
    
    public init(
        routeId: String, 
        isFavorites: Bool,
        routeName: String,
        busType: String,
        firstArrivalTime: String,
        secondArrivalTime: String,
        isAlarmOn: Bool
    ) {
        self.routeId = routeId
        self.isFavorites = isFavorites
        self.routeName = routeName
        self.busType = BusType(rawValue: busType) ?? .normal
        self.firstArrivalTime = firstArrivalTime
        self.secondArrivalTime = secondArrivalTime
        self.isAlarmOn = isAlarmOn
    }
}

public enum BusType: String, Codable {
    case normal = "0", lowFloor = "1", articulated = "2"
//    case 공용 = "0"
//    case 공항 = "1"
//    case 마을 = "2"
//    case 간선 = "3"
//    case 지선 = "4"
//    case 순환 = "5"
//    case 광역 = "6"
//    case 인천 = "7"
//    case 경기 = "8"
//    case 폐지 = "9"
    public var toString: String {
        switch self {
        case .normal:
            return "일반버스"
        case .lowFloor:
            return "저상버스"
        case .articulated:
            return "굴절버스"
        }
    }
}
