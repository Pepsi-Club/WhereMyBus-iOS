//
//  MockStationLIstRepository.swift
//  FeatureDependency
//
//  Created by 유하은 on 2024/03/07.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

import RxSwift

#if DEBUG
public final class MockStationLIstRepository: StationListRepository {
    public func saveRecentSearch(_ searchCell: [Domain.BusStopInfoResponse]) {
        
    }
    
    public func jsontoSearchData() -> Observable<[BusStopInfoResponse]> {
        .just([])
    }
    
    public func getRecentSearch() -> Observable<[BusStopInfoResponse]> {
        .just([])
    }
    
    public var busStopInfoList: [BusStopInfoResponse]
    
    public func jsontoSearchData() {
    }
    
    public func saveRecentSearch(_ searchText: String) {
    }
    
    public var searchResponse = BehaviorSubject<[BusStopInfoResponse]>(value: [])
    
    public init(){
        busStopInfoList = []
    }
    
    public func fetchJsonList() -> Observable<BusStopInfoResponse> {
        .create { observer in
            observer.onNext(
                BusStopInfoResponse(
                busStopName: "청운중학교",
                busStopId: "01105",
                direction: "경복고교",
                longitude: "37.587809",
                latitude: "126.972673")
        )
            return Disposables.create()

        }
    }
}
#endif
