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
import FirebaseModule

extension AppDelegate {
    func registerDependencies() {
        let coreDataService: CoreDataService = DefaultCoreDataService()
        let networkService: NetworkService = DefaultNetworkService()
        let locationService: LocationService = DefaultLocationService()
		
        let favoritesRepository: FavoritesRepository
        = DefaultFavoritesRepository(
            coreDataService: coreDataService,
            networkService: networkService
        )
        let busStopArrivalInfoRepository: BusStopArrivalInfoRepository
        = DefaultBusStopArrivalInfoRepository(networkService: networkService)
        let stationListRepository: StationListRepository
        = DefaultStationListRepository()
        let regularAlarmRepository: RegularAlarmRepository
        = DefaultRegularAlarmRepository(
            coreDataService: coreDataService,
            networkService: networkService
        )
        let localNotificationService: LocalNotificationService
        = DefaultLocalNotificationService()
        let regularAlarmEditingService: RegularAlarmEditingService
        = DefaultRegularAlarmEditingService()
        // TODO: 추후 의존 주입 형태 변경
//        let versionCheckRepository: VersionCheckRepository
//        = DefaultVersionCheckRepository(networkService: networkService)
        
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
                localNotificationService: localNotificationService,
                regularAlarmRepository: regularAlarmRepository
            )
        )
        
        DIContainer.register(
            type: AddRegularAlarmUseCase.self,
            DefaultAddRegularAlarmUseCase(
                localNotificationService: localNotificationService, 
                regularAlarmRepository: regularAlarmRepository
            )
        )
        
        DIContainer.register(
            type: SearchUseCase.self,
            DefaultSearchUseCase(
                stationListRepository: stationListRepository, 
                locationService: locationService
            )
        )
        
        DIContainer.register(
            type: BusStopUseCase.self,
            DefaultBusStopUseCase(
                busStopArrivalInfoRepository: busStopArrivalInfoRepository,
                favoritesRepository: favoritesRepository,
                regularAlarmEditingService: regularAlarmEditingService
            )
        )
        
        DIContainer.register(
            type: NearMapUseCase.self,
            DefaultNearMapUseCase(
                stationListRepository: stationListRepository, 
                locationService: locationService
            )
        )
        
        DIContainer.register(
            type: RegularAlarmEditingService.self,
            regularAlarmEditingService
        )
        
//        DIContainer.register(
//            type: VersionCheckUseCase.self,
//            DefaultVersionCheckUseCase(
//                versionCheckRepository: versionCheckRepository
//            )
//        )
        DIContainer.register(type: FirebaseLogger.self, FirebaseLoggerImpl())
    }
}
