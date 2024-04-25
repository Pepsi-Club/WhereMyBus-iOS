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
    private let disposeBag = DisposeBag()
    
    public init(
        busStopArrivalInfoRepository: BusStopArrivalInfoRepository,
        favoritesRepository: FavoritesRepository
    ) {
        self.busStopArrivalInfoRepository = busStopArrivalInfoRepository
        self.favoritesRepository = favoritesRepository
    }
    
    public func fetchNextPage() -> Observable<[BusStopArrivalInfoResponse]> {
        fetchItemLimit += 5
        favoritesRepository.fetchFavorites()
        return favoritesRepository.favorites
            .withUnretained(self)
            .flatMap { useCase, favoritesList in
                Observable.zip(
                    favoritesList
                        .prefix(useCase.fetchItemLimit)
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
            }
            .withLatestFrom(
                favoritesRepository.favorites
            ) { responses, favoritesList in
                (responses, favoritesList)
            }
            .map { responses, favoritesList in
                let result = responses
                    .updateFavoritesStatus(
                        favoritesList: favoritesList
                    )
                    .map { response in
                        response.filterUnfavoritesBuses()
                    }
                return result
            }
    }
    
    public func fetchFirstPage(
    ) -> Observable<[BusStopArrivalInfoResponse]> {
        fetchItemLimit = 0
        return fetchNextPage()
    }
    
    public func fetchAllFavorites(
    ) -> Observable<[BusStopArrivalInfoResponse]> {
        favoritesRepository.fetchFavorites()
        return favoritesRepository.favorites
            .withUnretained(self)
            .flatMap { useCase, favoritesList in
                Observable.zip(
                    favoritesList
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
            }
            .withLatestFrom(
                favoritesRepository.favorites
            ) { responses, favoritesList in
                (responses, favoritesList)
            }
            .map { responses, favoritesList in
                let result = responses
                    .updateFavoritesStatus(
                        favoritesList: favoritesList
                    )
                    .map { response in
                        response.filterUnfavoritesBuses()
                    }
                return result
            }
    }
}
