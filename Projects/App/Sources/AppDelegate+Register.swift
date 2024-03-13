//
//  AppDelegate+Register.swift
//  AppStore
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import Foundation

import Core
import CoreDataService
import Data
import Domain
import NetworkService

extension AppDelegate {
    func registerDependencies() {
        let coreDataService: CoreDataService = DefaultCoreDataService()
        let networkService: NetworkService = DefaultNetworkService()
        
        let favoritesRepository: FavoritesRepository
        = DefaultFavoritesRepository(coreDataService: coreDataService)
        let busStopArrivalInfoRepository: BusStopArrivalInfoRepository
        = DefaultBusStopArrivalInfoRepository(networkService: networkService)
        let stationListRepository: StationListRepository
        = DefaultStationListRepository()
        let localNotificationService: LocalNotificationService
        = DefaultLocalNotificationService()
        
        DIContainer.register(
            type: FavoritesUseCase.self,
            DefaultFavoritesUseCase(
                busStopArrivalInfoRepository: busStopArrivalInfoRepository,
                favoritesRepository: favoritesRepository
            )
        )
        
        DIContainer.register(
            type: RegularAlarmUseCase.self,
            DefaultRegularAlarmUseCase(
                localNotificationService: localNotificationService
            )
        )
        
        DIContainer.register(
            type: AddRegularAlarmUseCase.self,
            DefaultAddRegularAlarmUseCase(
                localNotificationService: localNotificationService
            )
        )
        
        DIContainer.register(
            type: SearchUseCase.self,
            DefaultSearchUseCase(stationListRepository: stationListRepository)
        )
        
        DIContainer.register(
            type: BusStopUseCase.self,
            DefaultBusStopUseCase(
                busStopArrivalInfoRepository: busStopArrivalInfoRepository,
                favoritesRepository: favoritesRepository
            )
        )
    }
}
