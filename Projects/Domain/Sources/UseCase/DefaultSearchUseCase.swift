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

    private let disposeBag = DisposeBag()
   
    public var recentSearchResult =
        BehaviorSubject<[BusStopInfoResponse]>(value: [])
    public let jsontoSearchData =
        PublishSubject<[BusStopInfoResponse]>()
    public var filteringText =
        BehaviorSubject<[BusStopInfoResponse]>(value: [])
    
    public init(stationListRepository: StationListRepository) {
        self.stationListRepository = stationListRepository
        
        getRecentSearchList()
    }
    
    public func getStationList() {
        stationListRepository.jsontoSearchData()
            .bind(to: jsontoSearchData)
            .disposed(by: disposeBag)
    }
    
    public func getRecentSearchList() {
        stationListRepository.getRecentSearch()
            // map은 형태를 바꿔줌
            .bind(to: recentSearchResult)
            .disposed(by: disposeBag)
    }
    
    public func getFiltering(searchtext: String) {
        stationListRepository.jsontoSearchData()
            .map { responses in
                return responses.filter {
                    $0.busStopName.contains(searchtext)
                }
            }
            .bind(to: filteringText)
            .disposed(by: disposeBag)
    }
}
