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
    
    public var favorites = BehaviorSubject<FavoritesResponse>(
        value: .init(busStops: [])
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
                .busStops
            Observable.combineLatest(
                favoritesBusStops
                    .map { response in
                        busStopArrivalInfoRepository.fetchArrivalList(
                            busStopId: response.busStopId,
                            busStopName: response.busStopName
                        )
                    }
            )
            .withUnretained(self)
            .map { useCase, responses in
                useCase.filterFavorites(
                    responses: responses,
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
        responses: [BusStopArrivalInfoResponse],
        favoritesBusStops: [BusStopArrivalInfoResponse]
    ) -> [BusStopArrivalInfoResponse] {
        responses.filter { busStop in
            busStop.buses.contains { bus in
                favoritesBusStops.contains { busStop in
                    busStop.buses.contains { busRequest in
                        busRequest.routeId == bus.routeId
                    }
                }
            }
        }
    }
}
