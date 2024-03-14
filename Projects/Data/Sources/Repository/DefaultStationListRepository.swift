//
//  DefaultStationListRepository.swift
//  Data
//
//  Created by 유하은 on 2024/02/27.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

import RxSwift
import RxRelay

public final class DefaultStationListRepository: StationListRepository {
    public let stationList = BehaviorSubject<[BusStopInfoResponse]>(value: [])
    public let recentlySearchedStation
    = BehaviorRelay<[BusStopInfoResponse]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    private let userDefaultsKey = "recentSearches"
    private let maxRecentSearchCount = 5
    
    public init() {
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
