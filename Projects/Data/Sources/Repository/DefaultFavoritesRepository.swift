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
import NetworkService

import RxSwift

public final class DefaultFavoritesRepository: FavoritesRepository {
    private let coreDataService: CoreDataService
    private let networkService: NetworkService
    
    public var favorites = BehaviorSubject<[FavoritesBusResponse]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    public init(
        coreDataService: CoreDataService,
        networkService: NetworkService
    ) {
        self.coreDataService = coreDataService
        self.networkService = networkService
        bindStoreStatus()
    }
    
    public func addFavorites(favorites: FavoritesBusResponse) throws {
        try coreDataService.saveUniqueData(
            data: favorites,
            uniqueKeyPath: \.identifier
        )
        fetchFavorites()
    }
    
    public func removeFavorites(favorites: FavoritesBusResponse) throws {
        try coreDataService.delete(
            data: favorites,
            uniqueKeyPath: \.identifier
        )
        fetchFavorites()
    }
    
    private func bindStoreStatus() {
        coreDataService.storeStatus
            .withUnretained(self)
            .subscribe(
                onNext: { repository, storeStatus in
                    if storeStatus == .loaded {
                        DispatchQueue.global().async {
                            repository.migrateFavorites()
                        }
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func fetchFavorites() {
        do {
            let fetchedFavorites = try coreDataService.fetch(
                type: FavoritesBusResponse.self
            )
            favorites.onNext(fetchedFavorites)
        } catch {
            favorites.onError(error)
        }
    }
    
    private func migrateFavorites() {
        do {
            let legacyFavoritesList = try coreDataService
                .fetch(
                    type: FavoritesBusStopResponse.self
                )
            let legacyFavofitesFilteredList = legacyFavoritesList
                .filterDuplicated()
            guard !legacyFavoritesList.isEmpty
            else {
                fetchFavorites()
                return
            }
            Observable.merge(
                legacyFavofitesFilteredList.map {
                    networkService.request(
                        endPoint: BusStopArrivalInfoEndPoint(
                            arsId: $0.busStopId
                        )
                    )
                }
            )
            .decode(
                type: BusStopArrivalInfoDTO.self,
                decoder: JSONDecoder()
            )
            .compactMap { $0.toDomain }
            .withUnretained(self)
                .subscribe(
                    onNext: { repository, response in
                        guard let favorites = legacyFavofitesFilteredList
                            .first(where: { favorites in
                                favorites.busStopId == response.busStopId
                            })
                        else { return }
                        response.buses.filter { bus in
                            favorites.busIds.contains(bus.busId)
                        }
                        .forEach { bus in
                            let newFavorites = FavoritesBusResponse(
                                busStopId: response.busStopId,
                                busStopName: response.busStopName,
                                busId: bus.busId,
                                busName: bus.busName,
                                adirection: bus.adirection
                            )
                            do {
                                try repository.coreDataService
                                    .saveUniqueData(
                                        data: newFavorites,
                                        uniqueKeyPath: \.identifier
                                    )
                            } catch {
                                #if DEBUG
                                print(error.localizedDescription)
                                #endif
                            }
                        }
                        legacyFavoritesList.filter { legacyFavorites in
                            legacyFavorites.busStopId == response.busStopId
                        }
                        .forEach { legacyFavorites in
                            try? repository.coreDataService.delete(
                                data: legacyFavorites,
                                uniqueKeyPath: \.busStopId
                            )
                        }
                    },
                    onDisposed: { [weak self] in
                        self?.fetchFavorites()
                    }
                )
                .disposed(by: disposeBag)
        } catch {
            #if DEBUG
            print(error.localizedDescription)
            #endif
        }
    }
}
