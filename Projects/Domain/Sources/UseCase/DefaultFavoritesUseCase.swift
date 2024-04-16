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
        bindFavorites()
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
                            busStopResponse.filterUnfavoritesBuses()
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
    
    private func bindFavorites() {
        favoritesRepository.favorites
            .withLatestFrom(
                busStopArrivalInfoResponse
            ) { favorites, responses in
                (favorites, responses)
            }
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, tuple in
                    let (favoritesList, responses) = tuple
                    let favoritesBusStopId = Set(
                        favoritesList.map { favorites in
                            favorites.busStopId
                        }
                    )
                    let currentBusStopId = responses.map { $0.busStopId }
                    let unfetchedBusStopIds = favoritesBusStopId.subtracting(
                        currentBusStopId
                    )
                    guard !unfetchedBusStopIds.isEmpty
                    else { return }
                    Observable.merge(
                        unfetchedBusStopIds.map { busStopId in
                            useCase.busStopArrivalInfoRepository
                                .fetchArrivalList(busStopId: busStopId)
                        }
                    )
                    .subscribe(
                        onNext: { response in
                            do {
                                let currentResponse = try useCase
                                    .busStopArrivalInfoResponse.value()
                                let updatedResponse = response
                                    .updateFavoritesStatus(
                                        favoritesList: favoritesList
                                    )
                                    .filterUnfavoritesBuses()
                                useCase.busStopArrivalInfoResponse.onNext(
                                    currentResponse + [updatedResponse]
                                )
                            } catch {
                                #if DEBUG
                                print(error.localizedDescription)
                                #endif
                            }
                        }
                    )
                    .disposed(by: useCase.disposeBag)
                }
            )
            .disposed(by: disposeBag)
    }
}
