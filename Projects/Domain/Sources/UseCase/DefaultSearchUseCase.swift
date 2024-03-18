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
    
    public let searchedStationList = PublishSubject<[BusStopInfoResponse]>()
    public var recentSearchResult = BehaviorSubject<[BusStopInfoResponse]>(
        value: []
    )
    
    public init(stationListRepository: StationListRepository) {
        self.stationListRepository = stationListRepository
        bindRecentSearchList()
    }
    
    public func search(term: String) {
        do {
            let filteredList = try stationListRepository.stationList.value()
                .filter { response in
                    (
                        term.count > 3 &&
                        response.busStopId.prefix(term.count) == term
                    ) ||
                    response.busStopName.contains(term)
                }
            searchedStationList.onNext(filteredList)
        } catch {
            searchedStationList.onError(error)
        }
    }
    
    public func removeRecentSearch() {
        stationListRepository.removeRecentSearch()
    }
    
    public func saveRecentSearch(cell: BusStopInfoResponse) {
        stationListRepository.saveRecentSearch(cell)
    }
    
    public func getBusStopInfo(for busStopId: String
    ) -> Observable<[BusStopInfoResponse]> {
        return stationListRepository.stationList
            .map { stationList in
                return stationList.filter { $0.busStopId == busStopId }
        }
    }
    
    private func bindRecentSearchList() {
        stationListRepository.recentlySearchedStation
            .bind(to: recentSearchResult)
            .disposed(by: disposeBag)
    }
    
}
