//
//  AppDelegate+Register.swift
//  AppStore
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import Foundation

import Core
import Data
import Domain
import Networks

extension AppDelegate {
    func registerDependencies() {
        DIContainer.register(
            type: FavoritesUseCase.self,
            DefaultFavoritesUseCase(
                stationArrivalInfoRepository: stationArrivalInfoRepository
            )
        )
    }
}

extension AppDelegate {
    var stationArrivalInfoRepository: StationArrivalInfoRepository {
        DefaultStationArrivalInfoRepository(networkService: networkService)
    }
}

extension AppDelegate {
    var networkService: NetworkService {
        DefaultNetworkService()
    }
}
