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
    
    public func fetchFavorites() {
        coreDataService.fetch(
            type: FavoritesBusResponse.self
        )
        .withUnretained(self)
        .subscribe(
            onNext: { repository, favoritesList in
                repository.favorites.onNext(favoritesList)
            }
        )
        .disposed(by: disposeBag)
    }
    
    private func migrateFavorites() {
        coreDataService.fetch(type: FavoritesBusStopResponse.self)
            .withUnretained(self)
            .filter { repository, legacyFavoritesList in
                let needMigration = !legacyFavoritesList.isEmpty
                if !needMigration {
                    repository.fetchFavorites()
                }
                return needMigration
            }
            .flatMap { repository, legacyFavoritesList in
                repository.fetchLegacyFavoritesToBusStop(
                    legacyFavoritesList: legacyFavoritesList.filterDuplicated()
                )
                .map { ($0, legacyFavoritesList) }
            }
            .withUnretained(self)
            .subscribe(
                onNext: { repository, tuple in
                    repository.updateLegacyToNewFavorites(
                        busStopList: tuple.0,
                        legacyFavoritesList: tuple.1
                    )
                    repository.fetchFavorites()
                },
                onError: { [weak self] _ in
                    self?.fetchFavorites()
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func updateLegacyToNewFavorites(
        busStopList: [BusStopArrivalInfoResponse],
        legacyFavoritesList: [FavoritesBusStopResponse]
    ) {
        let busStopDic = Dictionary(
            uniqueKeysWithValues: busStopList.map {
                ($0.busStopId, $0)
            }
        )
        for legacyFavorites in legacyFavoritesList {
            guard let busStop = busStopDic[legacyFavorites.busStopId]
            else { return }
            let busesDic = Dictionary(
                uniqueKeysWithValues: busStop.buses.map { bus in
                    (bus.busId, bus)
                }
            )
            var successedMigratedBusId = [String]()
            legacyFavorites.busIds.forEach { legacyBusId in
                guard let bus = busesDic[legacyBusId]
                else { return }
                let newData = FavoritesBusResponse(
                    busStopId: busStop.busStopId,
                    busStopName: busStop.busStopName,
                    busId: bus.busId,
                    busName: bus.busName,
                    adirection: bus.adirection
                )
                do {
                    try coreDataService.saveUniqueData(
                        data: newData,
                        uniqueKeyPath: \.identifier
                    )
                    successedMigratedBusId.append(newData.busId)
                } catch {
                    #if DEBUG
                    print(error.localizedDescription)
                    #endif
                }
            }
            if legacyFavorites.busIds == successedMigratedBusId {
                try? coreDataService.delete(
                    data: legacyFavorites,
                    uniqueKeyPath: \.busStopId
                )
            } else {
                let failedMigratedBusId = Array(
                    Set(legacyFavorites.busIds).subtracting(
                        Set(successedMigratedBusId)
                    )
                )
                try? coreDataService.update(
                    data: FavoritesBusStopResponse(
                        busStopId: legacyFavorites.busStopId,
                        busIds: failedMigratedBusId
                    ),
                    uniqueKeyPath: \.busStopId
                )
            }
        }
    }
    
    private func fetchLegacyFavoritesToBusStop(
        legacyFavoritesList: [FavoritesBusStopResponse]
    ) -> Observable<[BusStopArrivalInfoResponse]> {
        Observable.zip(
            legacyFavoritesList.map { favorite in
                networkService.request(
                    endPoint: BusStopArrivalInfoEndPoint(
                        arsId: favorite.busStopId
                    )
                )
                .decode(
                    type: BusStopArrivalInfoDTO.self,
                    decoder: JSONDecoder()
                )
                .compactMap { $0.toDomain }
            }
        )
    }
}
