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
    
    public let busStopSection = PublishSubject<BusStopArrivalInfoResponse>()
    public var favorites = BehaviorSubject<[FavoritesBusStopResponse]>(
        value: .init([])
    )
    private let disposeBag = DisposeBag()
    
    public init(
        busStopArrivalInfoRepository: BusStopArrivalInfoRepository,
        favoritesRepository: FavoritesRepository
    ) {
        self.busStopArrivalInfoRepository = busStopArrivalInfoRepository
        self.favoritesRepository = favoritesRepository
        
        fetchFavorites()
        
    }
    
    public func fetchBusArrivals(request: ArrivalInfoRequest) {
        let busStops = busStopArrivalInfoRepository.fetchArrivalList(
            busStopId: request.busStopId
        )
        .map { $0 }
        Observable.combineLatest(busStops, favorites)
            .withUnretained(self)
            .map { useCase, arg1 in
                var (busStops, favoritesBusStops) = arg1
                busStops = useCase.filterFavorites(
                    responses: busStops,
                    favorites: favoritesBusStops
                )
                return busStops
            }
            .bind(to: busStopSection)
            .disposed(by: disposeBag)
    }
    // MARK: - 즐겨찾기 데이터 가져오기
    private func fetchFavorites() {
        favoritesRepository.favorites
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                onNext: { useCase, favorites in
                    print("✅ \(favorites)")
                    useCase.favorites.onNext(favorites)
                }
            )
            .disposed(by: disposeBag)
    }
    // MARK: - 필터링 후 BusStopArrivalInfoRepsonse 반환
    public func filterFavorites(
        responses: BusStopArrivalInfoResponse,
        favorites: [FavoritesBusStopResponse]
    ) -> BusStopArrivalInfoResponse {
        var busStops = responses
        
        guard let favorite = favorites.first(
            where: {
                $0.busStopId == busStops.busStopId
            }
        ) else {
            return busStops // favorites에 해당하는 것이 없으면 그대로 반환
        }
        
        for favoriteBusId in favorite.busIds {
            if let indexInResponse = responses.buses.firstIndex(
                where: {
                    $0.busId == favoriteBusId
                }
            ) {
                busStops.buses[indexInResponse].isFavorites
                = !busStops.buses[indexInResponse].isFavorites
            }
        }
        return busStops
    }
    
    // MARK: - 즐찾 추가 및 해제
    public func handleFavorites(
        busStop: String,
        bus: BusArrivalInfoResponse
    ) {
        if bus.isFavorites {
            self.favoritesRepository.removeRoute(arsId: busStop, bus: bus)
        } else {
            self.favoritesRepository.addRoute(arsId: busStop, bus: bus)
        }
    }
}
