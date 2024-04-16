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
    
    public let busStopArrivalInfoResponse 
    = BehaviorSubject<[BusStopArrivalInfoResponse]>(value: [])
    private let disposeBag = DisposeBag()
    
    public init(
        busStopArrivalInfoRepository: BusStopArrivalInfoRepository,
        favoritesRepository: FavoritesRepository
    ) {
        self.busStopArrivalInfoRepository = busStopArrivalInfoRepository
        self.favoritesRepository = favoritesRepository
    }
    
    public func fetchFavoritesArrivals() {
        do {
            let favoritesList = try favoritesRepository.favorites.value()
            let favoritesBusStopId = Set(favoritesList.map { $0.busStopId })
            Observable.combineLatest(
                favoritesBusStopId
                    .map { busStopId in
                        busStopArrivalInfoRepository.fetchArrivalList(
                            busStopId: busStopId
                        )
                    }
            )
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, responses in
                    let updatedResponses = responses
                        .updateFavoritesStatus(
                            favoritesList: favoritesList
                        )
                        .map { busStopResponse in
                            let filteredBuses = busStopResponse.buses
                                .filter { busResponse in
                                    busResponse.isFavorites
                                }
                            return BusStopArrivalInfoResponse(
                                busStopId: busStopResponse.busStopId,
                                busStopName: busStopResponse.busStopName,
                                direction: busStopResponse.direction,
                                buses: filteredBuses
                            )
                        }
                    useCase.busStopArrivalInfoResponse.onNext(
                        updatedResponses
                    )
                }
            )
            .disposed(by: disposeBag)
        } catch {
            busStopArrivalInfoResponse.onError(error)
        }
    }
}
