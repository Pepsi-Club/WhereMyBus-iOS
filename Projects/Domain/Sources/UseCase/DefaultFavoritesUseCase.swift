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
    private let disposeBag = DisposeBag()
    
    public init(
        busStopArrivalInfoRepository: BusStopArrivalInfoRepository,
        favoritesRepository: FavoritesRepository
    ) {
        self.busStopArrivalInfoRepository = busStopArrivalInfoRepository
        self.favoritesRepository = favoritesRepository
    }
    
    public func fakeFetchComplete() {
        fetchItemLimit = 5
        isFinalPage = false
    }
    
    public func fetchNextPage() -> Observable<[BusStopArrivalInfoResponse]> {
        guard !isFinalPage
        else { return .just([]) }
        fetchItemLimit += 5
        favoritesRepository.fetchFavorites()
        return favoritesRepository.favorites
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
            .take(1)
    }
    
    public func fetchFirstPage(
    ) -> Observable<[BusStopArrivalInfoResponse]> {
        fetchItemLimit = 0
        isFinalPage = false
        return fetchNextPage()
    }
}
