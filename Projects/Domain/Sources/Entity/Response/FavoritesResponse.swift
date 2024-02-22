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
    public let busStopNum: String?
    public var buses: [BusArrivalInfoResponse]
    
    public init(
        busStopId: String,
        busStopName: String,
        direction: String,
        busStopNum: String?,
        buses: [BusArrivalInfoResponse]
    ) {
        self.busStopId = busStopId
        self.busStopName = busStopName
        self.direction = direction
        self.busStopNum = busStopNum
        self.buses = buses
    }
}

extension Array<BusStopArrivalInfoResponse> {
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
        self.busType = BusType(rawValue: busType) ?? .abolition
        self.firstArrivalTime = firstArrivalTime
        self.secondArrivalTime = secondArrivalTime
        self.isAlarmOn = isAlarmOn
    }
}

public enum BusType: String, Codable {
    case common = "0"
    case airport = "1"
    case village = "2"
    case trunkLine = "3"
    case branchLine = "4"
    case circulation = "5"
    case wideArea = "6"
    case incheon = "7"
    case gyeonggi = "8"
    case abolition = "9"
    
    public var toString: String {
        switch self {
        case .common:
            return "공용"
        case .airport:
            return "공항"
        case .village:
            return "마을"
        case .trunkLine:
            return "간선"
        case .branchLine:
            return "지선"
        case .circulation:
            return "순환"
        case .wideArea:
            return "광역"
        case .incheon:
            return "인천"
        case .gyeonggi:
            return "경기"
        case .abolition:
            return "폐지"
        }
    }
}
