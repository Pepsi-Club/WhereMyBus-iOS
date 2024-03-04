//
//  DefaultFavoritesRepository.swift
//  Data
//
//  Created by gnksbm on 1/30/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import CoreDataService
import Domain

import RxSwift

public final class DefaultFavoritesRepository: FavoritesRepository {
    private let coreDataService: CoreDataService
    
    public var favorites = BehaviorSubject<[FavoritesBusStopResponse]>(
        value: []
    )
    private let disposeBag = DisposeBag()
    
    public init(
        coreDataService: CoreDataService
    ) {
        self.coreDataService = coreDataService
        fetchFavorites()
    }
    
    public func addRoute(
        arsId: String,
        bus: BusArrivalInfoResponse
    ) {
        do {
            var oldFavorites = try favorites.value()
            if oldFavorites.contains(where: { $0.busStopId == arsId }) {
                guard let favoriteToChange = oldFavorites
                    .first(where: { $0.busStopId == arsId })
                else { return }
                let newBusIds = favoriteToChange.busIds + [bus.busId]
                var newFavorites = oldFavorites.filter { $0.busStopId == arsId }
                newFavorites.append(
                    .init(
                        busStopId: arsId,
                        busIds: newBusIds
                    )
                )
                favorites.onNext(newFavorites)
                return
            }
            oldFavorites.append(
                .init(
                    busStopId: arsId,
                    busIds: [bus.busId]
                )
            )
            favorites.onNext(oldFavorites)
        } catch {
            print(error, "즐겨찾기 업데이트 실패")
        }
    }
    
    public func removeRoute(
        arsId: String,
        bus: BusArrivalInfoResponse
    ) {
        do {
            let newFavorites = try favorites.value()
            favorites.onNext(newFavorites)
        } catch {
            print(error, "즐겨찾기 업데이트 실패")
        }
    }
    
    private func fetchFavorites() {
        do {
            let fetchedFavorites = try coreDataService.fetch(
                type: FavoritesBusStopResponse.self
            )
            favorites.onNext(fetchedFavorites)
        } catch {
            favorites.onError(error)
        }
    }
}
