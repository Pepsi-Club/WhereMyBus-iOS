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
    public private(set) var isFinalPage = false
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
                let favoritesIds = favoritesList.toBusStopIds
                let missedStopIds = Set(favoritesIds)
                    .subtracting(Set(cachedStopId))
                guard missedStopIds.isEmpty
                else {
                    return useCase.fetchFirstPage()
                }
                let cachedResult = Array(
                    useCase.cachedResponses
                        .prefix(useCase.fetchItemLimit)
                )
                .filterUnfavorites(favoritesList: favoritesList)
                useCase.cachedResponses = cachedResult
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
                let emptyResult = Observable.just(
                    ([BusStopArrivalInfoResponse](), favoritesList)
                )
                let favoritesIds = favoritesList.toBusStopIds
                guard !favoritesIds.isEmpty
                else {
                    return emptyResult
                }
                let suffixCount = min(
                    favoritesIds.count - (useCase.fetchItemLimit - 5),
                    5
                )
                guard suffixCount > 0
                else {
                    useCase.isFinalPage = true
                    return emptyResult
                }
                let idsToRequest = favoritesIds
                    .prefix(useCase.fetchItemLimit)
                    .suffix(suffixCount)
                return Observable.zip(
                    idsToRequest.map { busStopId in
                        useCase.busStopArrivalInfoRepository.fetchArrivalList(
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
                    .filterUnfavorites(favoritesList: favoritesList)
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
