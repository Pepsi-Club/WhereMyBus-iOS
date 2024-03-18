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
    public let locationService: LocationService
    public let stationList = BehaviorSubject<[BusStopInfoResponse]>(value: [])
    public let recentlySearchedStation
    = BehaviorRelay<[BusStopInfoResponse]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    private let userDefaultsKey = "recentSearches"
    private let maxRecentSearchCount = 5
    
    public init(
        locationService: LocationService
    ) {
        self.locationService = locationService
        fetchStationList()
        fetchRecentlySearched()
    }
    
    // MARK: 최근 검색어 저장
    public func saveRecentSearch(_ searchCell: [BusStopInfoResponse]) {
        var currentSearches = recentlySearchedStation.value
        
        // 최대 갯수에 도달하면 가장 오래된 항목을 제거
        if currentSearches.count >= maxRecentSearchCount {
            currentSearches.removeFirst()
        }
        
        currentSearches.append(contentsOf: searchCell)
        
        guard let data = currentSearches.encode()
        else { return }
        
        UserDefaults.standard.setValue(
            data,
            forKey: userDefaultsKey
        )
        recentlySearchedStation.accept(currentSearches)
    }
	
    /// 현재위치로 부터 가장 가까운 정류장을 구합니다.
    /// nearBusStop: 가장 가까운 정류장
    /// distance: 떨어진 거리(m,km)
    public func getBusStopNearCurrentLocation(
    ) throws -> (
        nearBusStop: BusStopInfoResponse,
        distance: String
    ) {
        self.locationService.requestLocationOnce()
        
        let myLocation = self.locationService.currentLocation
        var nearDistance = Int.max
        var nearBusStop = try stationList.value()[0]
        
        self.locationService.currentLocation
            .subscribe {
                _ = Observable.combineLatest(self.stationList, myLocation)
                    .subscribe { stationList, myLocation in
                        for (index, busStop) in stationList.enumerated() {
                            let (startLatitude, startlongitude) =
                            (myLocation.coordinate.latitude,
                             myLocation.coordinate.longitude)
                            let (endLatitude, endLongitude) =
                            (Double(busStop.latitude) ?? 0.0,
                             Double(busStop.longitude) ?? 0.0)
                            let startLocation = CLLocation(
                                latitude: startLatitude,
                                longitude: startlongitude
                            )
                            let endLocation = CLLocation(
                                latitude: endLatitude,
                                longitude: endLongitude
                            )
                            let distance = Int(endLocation.distance(
                                from: startLocation
                            ))
                            
                            if nearDistance > distance {
                                nearBusStop = stationList[index]
                                nearDistance = distance
                            }
                        }
                    }
            }
            .disposed(by: disposeBag)
        var stringDistance = "999m"
        
        if nearDistance > 999 {
            stringDistance =  "\(nearDistance / 1000)km"
        } else {
            stringDistance = "\(nearDistance)m"
        }
#if DEBUG
        print("🚏 가까운 정류장: \(nearBusStop.busStopName)")
        print("🚏 가까운 정류장으로 부터 거리\(stringDistance)")
#endif
        return ((nearBusStop, stringDistance))
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
