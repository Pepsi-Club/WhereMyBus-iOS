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
    
    public var favorites = BehaviorSubject<[FavoritesBusStopResponse]>(
        value: []
    )
    public let busStopArrivalInfoResponse 
    = BehaviorSubject<[BusStopArrivalInfoResponse]>(value: [])
    private let disposeBag = DisposeBag()
    
    public init(
        busStopArrivalInfoRepository: BusStopArrivalInfoRepository,
        favoritesRepository: FavoritesRepository
    ) {
        self.busStopArrivalInfoRepository = busStopArrivalInfoRepository
        self.favoritesRepository = favoritesRepository
        bindFavorites()
    }
    
    public func fetchFavoritesArrivals() {
        do {
            let favoritesBusStops = try favoritesRepository.favorites
                .value()
            Observable.combineLatest(
                favoritesBusStops
                    .map { response in
                        busStopArrivalInfoRepository.fetchArrivalList(
                            busStopId: response.busStopId
                        )
                    }
            )
            .withUnretained(self)
            .map { useCase, responses in
                useCase.filterFavorites(
                    fetchedResponses: responses,
                    favoritesBusStops: favoritesBusStops
                )
            }
            .bind(to: busStopArrivalInfoResponse)
            .disposed(by: disposeBag)
        } catch {
            busStopArrivalInfoResponse.onError(error)
        }
    }
    
    private func bindFavorites() {
        favoritesRepository.favorites
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, favorites in
                    useCase.favorites.onNext(favorites)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func filterFavorites(
        fetchedResponses: [BusStopArrivalInfoResponse],
        favoritesBusStops: [FavoritesBusStopResponse]
    ) -> [BusStopArrivalInfoResponse] {
        fetchedResponses.filter { fetchedBusStop in
            fetchedBusStop.buses.contains { fetchedBus in
                favoritesBusStops.contains { favoritebusStop in
                    favoritebusStop.busIds.contains { favoriteBusId in
                        favoriteBusId == fetchedBus.busId
                    }
                }
            }
        }
    }
}
