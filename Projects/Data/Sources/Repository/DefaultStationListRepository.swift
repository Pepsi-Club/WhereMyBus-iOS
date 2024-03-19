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
    public let stationList = BehaviorSubject<[BusStopInfoResponse]>(value: [])
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
    
    /// 현재위치로 부터 가장 가까운 정류장을 구합니다.
    /// nearBusStop: 가장 가까운 정류장
    /// distance: 떨어진 거리(m,km)
    public func getNearByStopInfo(
        startPointLocation: CLLocation
    ) -> BusStopInfoResponse {
        let errorResponse = BusStopInfoResponse(
            busStopName: "가까운 정류장을 찾을 수 없습니다.",
            busStopId: "",
            direction: "",
            longitude: "",
            latitude: ""
        )
        let errorDistance = ""
        do {
            let stationList = try stationList.value()
            var nearByStopDistance = Int.max
            var nearByStop = stationList.first ?? errorResponse
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
            return nearByStop
        } catch {
            return errorResponse
        }
    }
    
    private func fetchStationList() {
        guard let url = Bundle.main.url(
            forResource: "total_stationList",
            withExtension: "json"
        )
        else { return }
        do {
            let responses = try Data(contentsOf: url)
                .decode(type: BusStopListDTO.self)
                .toDomain
            stationList.onNext(responses)
        } catch {
            stationList.onError(error)
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
