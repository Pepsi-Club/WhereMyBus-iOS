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
        let firebaseLogger = FirebaseLoggerImpl()
        DIContainer.setLogger(firebaseLogger)
        
        DIContainer.register(type: ForceUpdateService.self, DefaultForceUpdateService())
        DIContainer.register(type: CoreDataService.self, DefaultCoreDataService())
        DIContainer.register(type: NetworkService.self, DefaultNetworkService())
        DIContainer.register(type: LocationService.self, DefaultLocationService())
        
        DIContainer.register(type: FavoritesRepository.self, DefaultFavoritesRepository())
        DIContainer.register(type: BusStopArrivalInfoRepository.self, DefaultBusStopArrivalInfoRepository())
        DIContainer.register(type: StationListRepository.self, DefaultStationListRepository())
        DIContainer.register(type: RegularAlarmRepository.self, DefaultRegularAlarmRepository())
        DIContainer.register(type: LocalNotificationService.self, DefaultLocalNotificationService())
        DIContainer.register(type: RegularAlarmEditingService.self, DefaultRegularAlarmEditingService())
        DIContainer.register(type: VersionCheckRepository.self, DefaultVersionCheckRepository())
        
        DIContainer.register(type: FavoritesUseCase.self, DefaultFavoritesUseCase())
        DIContainer.register(type: RegularAlarmUseCase.self, DefaultRegularAlarmUseCase())
        DIContainer.register(type: AddRegularAlarmUseCase.self, DefaultAddRegularAlarmUseCase())
        DIContainer.register(type: SearchUseCase.self, DefaultSearchUseCase())
        DIContainer.register(type: BusStopUseCase.self, DefaultBusStopUseCase())
        DIContainer.register(type: NearMapUseCase.self, DefaultNearMapUseCase())
        DIContainer.register(type: FirebaseLogger.self, firebaseLogger)
        DIContainer.register(type: VersionCheckUseCase.self, DefaultVersionCheckUseCase())
    }
}
