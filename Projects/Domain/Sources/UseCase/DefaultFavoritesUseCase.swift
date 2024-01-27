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
    private let stationArrivalInfoRepository: StationArrivalInfoRepository
    
    public let arrivalInfoList = PublishSubject<[StationArrivalInfoResponse]>()
    private let disposeBag = DisposeBag()
    
    public init(stationArrivalInfoRepository: StationArrivalInfoRepository) {
        self.stationArrivalInfoRepository = stationArrivalInfoRepository
    }
    
    public func requestStationArrivalInfo(
        favorites: Favorites
    ) {
        favorites.requests.forEach { request in
            stationArrivalInfoRepository.fetchArrivalList(
                request: request
            )
        }
        stationArrivalInfoRepository.responses
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, responses in
                    useCase.arrivalInfoList.onNext(responses)
                }
            )
            .disposed(by: disposeBag)
    }
}
