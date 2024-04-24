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
    
    public let fetchedArrivalInfo 
    = BehaviorSubject<[BusStopArrivalInfoResponse]>(value: [])
    private let disposeBag = DisposeBag()
    
    public init(
        busStopArrivalInfoRepository: BusStopArrivalInfoRepository,
        favoritesRepository: FavoritesRepository
    ) {
        self.busStopArrivalInfoRepository = busStopArrivalInfoRepository
        self.favoritesRepository = favoritesRepository
    }
    
    public func fetchFavoritesArrivals(
    ) -> Observable<[BusStopArrivalInfoResponse]> {
        favoritesRepository.fetchFavorites()
        return favoritesRepository.favorites
            .withUnretained(self)
            .filter { useCase, favoritesList in
                let shouldFetchFavorites = !favoritesList.isEmpty
                if !shouldFetchFavorites {
                    useCase.fetchedArrivalInfo.onNext([])
                }
                return shouldFetchFavorites
            }
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
