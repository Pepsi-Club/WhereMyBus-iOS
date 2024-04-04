//
//  DefaultStationListRepository.swift
//  Data
//
//  Created by 유하은 on 2024/02/27.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation
import CoreLocation

import Domain

import RxSwift
import RxRelay

public final class DefaultStationListRepository: StationListRepository {
    public let busStopRegions = BehaviorSubject<[BusStopRegion]>(value: [])
    public let recentlySearchedStation = BehaviorRelay<[BusStopInfoResponse]>(
        value: []
    )
    
    private let disposeBag = DisposeBag()
    
    private let userDefaultsKey = "recentSearches"
    private let maxRecentSearchCount = 5
    
    public init() {
        fetchStationList()
        fetchRecentlySearched()
    }
    
    public func saveRecentSearch(_ searchCell: BusStopInfoResponse) {
        var currentSearches = recentlySearchedStation.value

        if currentSearches.contains(searchCell) {
            currentSearches = [searchCell] + currentSearches
                .filter { $0 != searchCell }
        } else {
            // 최대 갯수에 도달하면 가장 오래된 항목을 제거
            if currentSearches.count >= maxRecentSearchCount {
                currentSearches.removeLast()
            }

            currentSearches.insert(searchCell, at: 0)
        }
        guard let data = currentSearches.encode()
        else { return }

        UserDefaults.standard.setValue(
            data,
            forKey: userDefaultsKey
        )
        recentlySearchedStation.accept(currentSearches)
    }
	
    public func removeRecentSearch() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        recentlySearchedStation.accept([])
    }
    
    public func getNearByStopInfo(
        startPointLocation: CLLocation
    ) -> (BusStopInfoResponse, String) {
        let errorResponse = BusStopInfoResponse(
            busStopName: "가까운 정류장을 찾을 수 없습니다.",
            busStopId: "",
            direction: "",
            longitude: "",
            latitude: ""
        )
        let errorDistance = ""
        do {
            let stationList = try busStopRegions.value()
                .flatMap { region in
                    switch region {
                    case .seoul(let responses):
                        return responses
                    }
                }
            var nearByStopDistance = Int.max
            var nearByStop = errorResponse
            stationList.forEach { busStop in
                guard let endPointLatitude = Double(busStop.latitude),
                      let endPointLongitude = Double(busStop.longitude)
                else { return }
                let distance = Int(
                    CLLocation(
                        latitude: endPointLatitude,
                        longitude: endPointLongitude
                    ).distance(from: startPointLocation)
                )
                if nearByStopDistance > distance {
                    nearByStop = busStop
                    nearByStopDistance = distance
                }
            }
            let distanceStr: String
            switch nearByStopDistance {
            case ..<1000:
                distanceStr = "\(nearByStopDistance)m"
            case Int.max:
                distanceStr = "측정거리 초과"
            default:
                distanceStr =  "\(nearByStopDistance / 1000)km"
            }
            return (nearByStop, distanceStr)
        } catch {
            return (errorResponse, errorDistance)
        }
    }
    
    private func fetchStationList() {
        guard let seoulUrl = Bundle.main.url(
            forResource: "total_stationList",
            withExtension: "json"
        )
        else { return }
        do {
            var regions = [BusStopRegion]()
            let seoul = try Data(contentsOf: seoulUrl)
                .decode(type: BusStopListDTO.self)
                .toDomain
            regions.append(seoul)
            busStopRegions.onNext(regions)
        } catch {
            busStopRegions.onError(error)
        }
    }
    
    private func fetchRecentlySearched() {
        guard let data = UserDefaults.standard.value(
            forKey: userDefaultsKey
        ) as? Data
        else { return }
        do {
            let fetchedResponses = try data
                .decode(type: [BusStopInfoResponse].self)
            recentlySearchedStation.accept(fetchedResponses)
        } catch {
            print(error.localizedDescription)
        }
    }
}
