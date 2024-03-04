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
    
    public var favorites = BehaviorSubject<FavoritesResponse>(
        value: .init(busStops: [])
    )
    private let disposeBag = DisposeBag()
    
    public init(
        coreDataService: CoreDataService
    ) {
        self.coreDataService = coreDataService
        fetchFavorites()
        bindUpdate()
    }
    
    public func addRoute(
        arsId: String,
        busStopName: String,
        direction: String,
        bus: BusArrivalInfoResponse
    ) {
        do {
            let newFavorites = try favorites.value().addRoute(
                busStopId: arsId,
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
        arsId: String,
        bus: BusArrivalInfoResponse
    ) {
        do {
            let newFavorites = try favorites.value().removeRoute(
                busStopId: arsId,
                bus: bus
            )
            favorites.onNext(newFavorites)
        } catch {
            print(error, "즐겨찾기 업데이트 실패")
        }
    }
    
    private func fetchFavorites() {
        /*
        // 수정될 로직
        do {
            let favorites = try coreDataService.fetch(
                type: FavoritesBusStopResponse.self
            )
            print(favorites)
        } catch {
            favorites.onError(error)
        }
         */
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
    
    private func bindUpdate() {
        favorites
            .subscribe(
                onNext: { response in
                    guard let data = response.encode() else { return }
                    UserDefaults.standard.setValue(data, forKey: "Favorites")
                }
            )
            .disposed(by: disposeBag)
    }
}
