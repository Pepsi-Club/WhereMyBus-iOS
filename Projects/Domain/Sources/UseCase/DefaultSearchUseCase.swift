//
//  DefaultSearchUseCase.swift
//  Domain
//
//  Created by 유하은 on 2024/03/07.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

public final class DefaultSearchUseCase: SearchUseCase {
    private let stationListRepository: StationListRepository
    
    public init(stationListRepository: StationListRepository) {
        self.stationListRepository = stationListRepository
    }
    
    public func searchBusStop(
        with searchText: String,
        busStopInfoList: [BusStopInfoResponse]
    ) -> [BusStopInfoResponse] {
        let filteredStops = busStopInfoList.filter { request in
            return request.busStopName.lowercased().contains(
                searchText.lowercased()
            )
        }
        return filteredStops
    }
    
    public func getStationList(){
        stationListRepository.jsontoSearchData()
    }
    
    public func getRecentSearch(){
        UserDefaults.standard.stringArray(forKey: "recentSearches")
    }
}
