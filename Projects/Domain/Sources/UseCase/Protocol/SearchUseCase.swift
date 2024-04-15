//
//  SearchUseCase.swift
//  Domain
//
//  Created by 유하은 on 2024/03/07.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol SearchUseCase {
    var locationStatus: BehaviorSubject<LocationStatus> { get }
    var nearByStopInfo: PublishSubject<(BusStopInfoResponse, String)> { get }
    var searchedStationList: PublishSubject<[BusStopRegion]> { get }
    var recentSearchResult: BehaviorSubject<[BusStopInfoResponse]> { get }
    
    func search(term: String)
    func removeRecentSearch()
    func saveRecentSearch(response: BusStopInfoResponse)
    func requestAuthorize()
    func getBusStopInfo(for busStopId: String
    ) -> Observable<[BusStopInfoResponse]>
    func updateNearByStop() -> Observable<(BusStopInfoResponse, String)>
}
