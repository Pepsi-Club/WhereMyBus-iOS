//
//  DefaultBusStopListRepository.swift
//  Data
//
//  Created by gnksbm on 1/28/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

import RxSwift

public final class DefaultBusStopListRepository: BusStopListRepository {
    public let busStopInfoResponse = BehaviorSubject<[BusStopInfoResponse]>(
        value: []
    )
    
    public init() {
        fetchLocalBusStopList()
    }
    
    private func fetchLocalBusStopList() {
        guard let url = Bundle.main.url(
            forResource: "total_stationList",
            withExtension: "json"
        )
        else { return }
        do {
            let data = try Data(contentsOf: url)
            let stationList = try JSONDecoder().decode(
                BusStopListDTO.self, from: data
            )
            busStopInfoResponse.onNext(stationList.toDomain)
        } catch {
            busStopInfoResponse.onError(error)
        }
    }
}
