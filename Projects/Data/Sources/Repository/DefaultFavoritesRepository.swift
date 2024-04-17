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
    
    public var favorites = BehaviorSubject<[FavoritesBusResponse]>(
        value: []
    )
    
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
                        repository.migrateFavorites()
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
            guard !legacyFavoritesList.isEmpty
            else {
                fetchFavorites()
                return
            }
            Observable
                .from(legacyFavoritesList.filterDuplicated())
                .withUnretained(self)
                .flatMap { repository, legacyFilteredFavorites in
                    repository.networkService.request(
                        endPoint: BusStopArrivalInfoEndPoint(
                            arsId: legacyFilteredFavorites.busStopId
                        )
                    )
                    .decode(
                        type: BusStopArrivalInfoDTO.self,
                        decoder: JSONDecoder()
                    )
                    .map { ($0.toDomain, legacyFilteredFavorites) }
                }
                .withUnretained(self)
                .subscribe(
                    onNext: { repository, tuple in
                        let (response, legacyFilteredFavorites) = tuple
                        do {
                            for legacyBusId in legacyFilteredFavorites.busIds {
                                guard let bus = response.buses.first(
                                    where: { $0.busId == legacyBusId }
                                ) else {
                                    continue
                                }
                                let favoritesResponse = FavoritesBusResponse(
                                    busStopId: response.busStopId,
                                    busStopName: response.busStopName,
                                    busId: bus.busId,
                                    busName: bus.busName,
                                    adirection: bus.adirection
                                )
                                try repository.coreDataService.saveUniqueData(
                                    data: favoritesResponse,
                                    uniqueKeyPath: \.identifier
                                )
                            }
                        } catch {
                            #if DEBUG
                            print(error.localizedDescription)
                            #endif
                            return
                        }
                        legacyFavoritesList.forEach { legacyFavorites in
                            try? self.coreDataService.delete(
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
