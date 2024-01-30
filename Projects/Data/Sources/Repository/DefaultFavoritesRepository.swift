//
//  DefaultFavoritesRepository.swift
//  Data
//
//  Created by gnksbm on 1/30/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

import RxSwift

public final class DefaultFavoritesRepository: FavoritesRepository {
    public var favorites = BehaviorSubject<FavoritesResponse>(
        value: .init(busStops: [])
    )
    private let disposeBag = DisposeBag()
    
    public init() {
        fetchFavorites()
    }
    
    public func addRoute(
        busStopId: String,
        busStopName: String,
        direction: String,
        bus: BusArrivalInfoResponse
    ) {
        do {
            let newFavorites = try favorites.value().addRoute(
                busStopId: busStopId,
                busStopName: busStopName,
                direction: direction,
                bus: bus
            )
            favorites.onNext(newFavorites)
        } catch {
            print(error, "즐겨찾기 업데이트 실패")
        }
    }
    
    public func removeRoute(
        busStopId: String,
        bus: BusArrivalInfoResponse
    ) {
        do {
            let newFavorites = try favorites.value().removeRoute(
                busStopId: busStopId,
                bus: bus
            )
            favorites.onNext(newFavorites)
        } catch {
            print(error, "즐겨찾기 업데이트 실패")
        }
    }
    
    private func fetchFavorites() {
        guard let data = UserDefaults.standard.data(forKey: "Favorites")
        else {
            favorites.onNext(.init(busStops: []))
            return
        }
        do {
            let savedFavorites = try JSONDecoder().decode(
                FavoritesResponse.self,
                from: data
            )
            favorites.onNext(savedFavorites)
        } catch {
            favorites.onError(error)
        }
    }
}
