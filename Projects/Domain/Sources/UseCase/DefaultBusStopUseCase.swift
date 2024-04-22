//
//  DefaultBusStopUseCase.swift
//  Domain
//
//  Created by Jisoo HAM on 2/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

public final class DefaultBusStopUseCase: BusStopUseCase {
    private let busStopArrivalInfoRepository: BusStopArrivalInfoRepository
    private let favoritesRepository: FavoritesRepository
    private let regularAlarmEditingService: RegularAlarmEditingService
    
    public let busStopSection = PublishSubject<BusStopArrivalInfoResponse>()
    private let disposeBag = DisposeBag()
    
    public init(
        busStopArrivalInfoRepository: BusStopArrivalInfoRepository,
        favoritesRepository: FavoritesRepository,
        regularAlarmEditingService: RegularAlarmEditingService
    ) {
        self.busStopArrivalInfoRepository = busStopArrivalInfoRepository
        self.favoritesRepository = favoritesRepository
        self.regularAlarmEditingService = regularAlarmEditingService
    }
    
    public func fetchBusArrivals(request: ArrivalInfoRequest) {
        let busStops = busStopArrivalInfoRepository.fetchArrivalList(
            busStopId: request.busStopId
        )
        Observable.combineLatest(
            busStops,
            favoritesRepository.favorites
        )
        .map { busStops, favorites in
            return busStops.updateFavoritesStatus(favoritesList: favorites)
        }
        .bind(to: busStopSection)
        .disposed(by: disposeBag)
    }
    
    // MARK: - 즐찾 추가 및 해제
    public func handleFavorites(
        isFavorites: Bool,
        favorites: FavoritesBusResponse
    ) throws {
        if isFavorites {
            try favoritesRepository.removeFavorites(favorites: favorites)
        } else {
            try favoritesRepository.addFavorites(favorites: favorites)
        }
    }
    // MARK: - Service - useCase - viewModel 연결
    public func update(
        busStopInfo: BusStopArrivalInfoResponse,
        busInfo: BusArrivalInfoResponse
    ) {
        regularAlarmEditingService.update(
            busStopId: busStopInfo.busStopId,
            busStopName: busStopInfo.busStopName,
            busId: busInfo.busId,
            busName: busInfo.busName,
            adirection: busInfo.adirection
        )
    }
}
