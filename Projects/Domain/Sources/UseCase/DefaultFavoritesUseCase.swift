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
    private let busStopArrivalInfoRepository: NewBusStopArrivalInfoRepository
    private let favoritesRepository: FavoritesRepository
    
    public let arrivalInfoList = PublishSubject<[RouteArrivalInfo]>()
    public let busArrivalInfoResponse = 
    PublishSubject<[BusArrivalInfoResponse]>()
    public let favorites = BehaviorSubject<FavoritesResponse>(
        value: .init(busStops: [])
    )
    
    private let disposeBag = DisposeBag()
    
    public init(
        busStopArrivalInfoRepository: NewBusStopArrivalInfoRepository,
        favoritesRepository: FavoritesRepository
    ) {
        self.busStopArrivalInfoRepository = busStopArrivalInfoRepository
        self.favoritesRepository = favoritesRepository
        bindFavorites()
    }
    
    public func requestBusStopArrivalInfo() {
        do {
            let favorites = try favorites.value()
            // Mock
            let request = ArrivalInfoRequest(
                busStopId: "테스트",
                busStopName: "테스트",
                routeName: ["테스트"]
            )
            busStopArrivalInfoRepository.fetchArrivalList(
                busStopId: request.busStopId,
                busStopName: request.busStopName
            )
            .map { response in
                response.buses.filter { response in
                    request.routeName
                        .contains { requestRouteName in
                            requestRouteName == response.routeName
                        }
                }
            }
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, responses in
                    useCase.busArrivalInfoResponse.onNext(responses)
                    useCase.arrivalInfoList.onNext(useCase.convert(responses))
                }
            )
            .disposed(by: disposeBag)
        } catch {
            print(#function, "Fail to favorites.value()")
        }
    }
    
    private func bindFavorites() {
        favoritesRepository.favorites
            .bind(to: favorites)
            .disposed(by: disposeBag)
    }
    
    private func convert(
        _ input: [BusArrivalInfoResponse]
    ) -> [RouteArrivalInfo] {
        input.map { response in
            let splittedMsg1 = response.firstArrivalTime
                .split(separator: "[")
                .map { String($0) }
            let splittedMsg2 = response.secondArrivalTime
                .split(separator: "[")
                .map { String($0) }
            let firstArrivalTime = splittedMsg1[0]
            let secondArrivalTime = splittedMsg2[0]
            var firstArrivalRemaining = ""
            var secondArrivalRemaining = ""
            if splittedMsg1.count > 1 {
                firstArrivalRemaining = splittedMsg1[1]
                firstArrivalRemaining.removeLast()
            }
            if splittedMsg2.count > 1 {
                secondArrivalRemaining = splittedMsg2[1]
                secondArrivalRemaining.removeLast()
            }
            return RouteArrivalInfo(
                routeName: response.routeName,
                firstArrivalTime: firstArrivalTime,
                firstArrivalRemaining: firstArrivalRemaining,
                secondArrivalTime: secondArrivalTime,
                secondArrivalRemaining: secondArrivalRemaining
            )
        }
    }
}
