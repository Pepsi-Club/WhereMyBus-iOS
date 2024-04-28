//
//  DefaultFavoritesUseCase.swift
//  Domain
//
//  Created by gnksbm on 1/26/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

public final class DefaultFavoritesUseCase: FavoritesUseCase {
    private let busStopArrivalInfoRepository: BusStopArrivalInfoRepository
    private let favoritesRepository: FavoritesRepository
    
    private var fetchItemLimit = 0
    private var isFinalPage = false
    private var cachedResponses = [BusStopArrivalInfoResponse]()
    private let disposeBag = DisposeBag()
    
    public init(
        busStopArrivalInfoRepository: BusStopArrivalInfoRepository,
        favoritesRepository: FavoritesRepository
    ) {
        self.busStopArrivalInfoRepository = busStopArrivalInfoRepository
        self.favoritesRepository = favoritesRepository
    }
    
    public func fakeFetch() -> Observable<[BusStopArrivalInfoResponse]> {
        fetchItemLimit = 5
        isFinalPage = false
        return favoritesRepository.fetchFavorites()
            .take(1)
            .withUnretained(self)
            .flatMap { useCase, favoritesList in
                let cachedStopId = useCase.cachedResponses.map { $0.busStopId }
                let favoritesIds = favoritesList.map { $0.busStopId }
                let missedStopIds = Set(cachedStopId)
                    .subtracting(Set(favoritesIds))
                if missedStopIds.isEmpty {
                    return useCase.fetchFirstPage()
                }
                let cachedResult = Array(
                    useCase.cachedResponses
                        .prefix(useCase.fetchItemLimit)
                )
                .updateFavoritesStatus(favoritesList: favoritesList)
                .map { $0.filterUnfavoritesBuses() }
                .filter { !$0.buses.isEmpty }
                return Observable.just(cachedResult)
            }
    }
    
    public func fetchFirstPage(
    ) -> Observable<[BusStopArrivalInfoResponse]> {
        cachedResponses.removeAll()
        fetchItemLimit = 0
        isFinalPage = false
        return fetchNextPage()
    }
    
    public func fetchNextPage(
    ) -> Observable<[BusStopArrivalInfoResponse]> {
        guard !isFinalPage
        else { return .just(cachedResponses) }
        fetchItemLimit += 5
        
        let fetchResult = favoritesRepository.fetchFavorites()
            .take(1)
            .withUnretained(self)
            .flatMapLatest { useCase, favoritesList in
                useCase.isFinalPage
                = favoritesList.count < useCase.fetchItemLimit
                let suffixCount = useCase.fetchItemLimit > 5 ?
                min(favoritesList.count % 5, 5) :
                5
                let fetchList = favoritesList
                    .prefix(useCase.fetchItemLimit)
                    .suffix(suffixCount)
                guard !favoritesList.isEmpty
                else {
                    return Observable.just(
                        ([BusStopArrivalInfoResponse](), favoritesList)
                    )
                }
                return Observable.zip(
                    fetchList
                        .lazy
                        .map {
                            $0.busStopId
                        }
                        .removeDuplicated()
                        .map { busStopId in
                            useCase.busStopArrivalInfoRepository
                                .fetchArrivalList(
                                    busStopId: busStopId
                                )
                        }
                )
                .map { responses in
                    (responses, favoritesList)
                }
            }
            .withUnretained(self)
            .map { useCase, tuple in
                let (responses, favoritesList) = tuple
                let result = (useCase.cachedResponses + responses)
                    .updateFavoritesStatus(
                        favoritesList: favoritesList
                    )
                    .map { response in
                        response.filterUnfavoritesBuses()
                    }
                return result
            }
            .share()
        fetchResult
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, responses in
                    useCase.cachedResponses = responses
                }
            )
            .disposed(by: disposeBag)
        return fetchResult
    }
}
