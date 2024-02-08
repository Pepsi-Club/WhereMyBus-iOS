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
    
    public let busStopSection = PublishSubject<[BusStopArrivalInfoResponse]>()
    private let disposeBag = DisposeBag()
    
    public init(
        busStopArrivalInfoRepository: BusStopArrivalInfoRepository
    ) {
        self.busStopArrivalInfoRepository = busStopArrivalInfoRepository
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
    
    // TODO: 즐겨찾기 추가 logic
}
