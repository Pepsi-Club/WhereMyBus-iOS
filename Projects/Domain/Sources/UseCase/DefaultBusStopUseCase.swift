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
    
    public let busStopSection = PublishSubject<[BusStopArrivalInfoResponse]>()
    public var favorites = BehaviorSubject<FavoritesResponse>(
        value: .init(busStops: [])
    )
    public var isFavorite = PublishSubject<Bool>()
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
        busStopArrivalInfoRepository.fetchArrivalList(
            busStopId: request.busStopId,
            busStopName: request.busStopName
        )
        .map { [$0] }
        .bind(to: busStopSection)
        .disposed(by: disposeBag)
    }
    // MARK: - 즐겨찾기 데이터 가져오기
    private func fetchFavorites() {
        favoritesRepository.favorites
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, favorites in
                    useCase.favorites.onNext(favorites)
                    print("\(favorites)")
                }
            )
            .disposed(by: disposeBag)
    }
    // MARK: - 필터링해서 -> bool 값 반환
    private func filterFavorites(
        responses: [BusStopArrivalInfoResponse],
        favorites: [BusStopArrivalInfoResponse]
    ) -> Bool {
        var isFavorite = false
//        let favoriteBuses = try favoritesRepository.favorites
//            .value()
//            .busStops
        isFavorite = responses.contains { response in
            if let matchFavBusStop = favorites.first(
                where: { $0.busStopId == response.busStopId }
            ) {
                response.buses.contains { bus in
                    matchFavBusStop.buses.contains { favoriteBus in
                        return favoriteBus.routeId == bus.routeId
                    }
                }
            }
            return false
        }
        
        return isFavorite
    }
    
    
    // MARK: - 즐찾 추가 및 해제
    
}
