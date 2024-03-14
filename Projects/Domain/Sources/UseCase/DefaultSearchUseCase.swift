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
    public let searchedStationList =
        PublishSubject<[BusStopInfoResponse]>()
    public var filteringText =
        BehaviorSubject<[BusStopInfoResponse]>(value: [])
    
    public init(stationListRepository: StationListRepository) {
        self.stationListRepository = stationListRepository
        
        getRecentSearchList()
    }
    
    public func search(term: String) {
        do {
            let filteredList = try stationListRepository.stationList.value()
                .filter { response in
                    response.busStopId.contains(term) ||
                    response.busStopName.contains(term)
                }
            searchedStationList.onNext(filteredList)
        } catch {
            searchedStationList.onError(error)
        }
    }
    // MARK: 전체 데이터 받아오기
    public func getStationList() {
        stationListRepository.stationList
            .bind(to: searchedStationList)
            .disposed(by: disposeBag)
    }
    
    // MARK: 최근 검색어 받아오기
    public func getRecentSearchList() {
        stationListRepository.recentlySearchedStation
            .bind(to: recentSearchResult)
            .disposed(by: disposeBag)
    }
    
    // MARK: 검색어 필터링 해서 연관 검색어 넘겨주기
    public func getFiltering(searchtext: String) {
        stationListRepository.stationList
            .map { responses in
                return responses.filter {
                    $0.busStopName.contains(searchtext)
                }
            }
            .bind(to: filteringText)
            .disposed(by: disposeBag)
    }
}
