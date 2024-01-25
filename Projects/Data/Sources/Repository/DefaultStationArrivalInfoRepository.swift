//
//  DefaultStationArrivalInfoRepository.swift
//  Data
//
//  Created by gnksbm on 1/25/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain
import Networks

import RxSwift
XMLParserDelegate
public final class DefaultStationArrivalInfoRepository
: StationArrivalInfoRepository {
    private let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchArrivalList(stationId: String) -> Observable<Data> {
        networkService.request(
            endPoint: StationArrivalInfoEndPoint(stationId: stationId)
        ).map {
            $0
        }
    }
}
