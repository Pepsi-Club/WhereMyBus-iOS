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
import Networks

extension AppDelegate {
    func registerDependencies() {
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
                regularAlarmRepository: regularAlarmRepository,
                localNotificationService: localNotificationService
            )
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

extension AppDelegate {
    var regularAlarmRepository: RegularAlarmRepository {
        DefaultRegularAlarmRepository()
    }
    var localNotificationService: LocalNotificationService {
        DefaultLocalNotificationService(
            busStopArrivalInfoRepository: busStopArrivalInfoRepository
        )
    }
    
    var favoritesRepository: FavoritesRepository {
        DefaultFavoritesRepository(coreDataService: coreDataService)
    }
    
    var busStopArrivalInfoRepository: BusStopArrivalInfoRepository {
        DefaultBusStopArrivalInfoRepository(networkService: networkService)
    }
}

extension AppDelegate {
    var coreDataService: CoreDataService {
        DefaultCoreDataService()
    }
    
    var networkService: NetworkService {
        DefaultNetworkService()
    }
}
