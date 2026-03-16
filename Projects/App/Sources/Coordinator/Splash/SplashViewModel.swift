//
//  SplashViewModel.swift
//  App
//
//  Created by gnksbm on 6/30/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import FeatureDependency
import NetworkService
import CoreDataService
import Data
import Domain
import Core
import FirebaseModule

import RxSwift
import RxRelay

protocol SplashViewModelDependency {
    var appVersion: AppVersionInfoResponse { get }
    var appStoreID: String { get }
    var domainURL: String { get }
}

final class SplashViewModel: ViewModel {
    private weak var coordinator: SplashCoordinator?
    @Injected private var versionCheckUseCase: AppVersionCheckUseCase
    @Injected private var firebaseLogger: FirebaseLogger
    private let dependency: SplashViewModelDependency
    
    init(
        coordinator: SplashCoordinator,
        dependency: SplashViewModelDependency
    ) {
        self.coordinator = coordinator
        self.dependency = dependency
    }
    
    func transform(input: Input) -> Output {
        let alertRelay = PublishRelay<Alert>()
        Task {
            try await input.viewDidLoad.value
            await registerDependency()
            do {
                let forceUpdate = try await versionCheckUseCase.checkForceUpdateNeeded()
                switch forceUpdate {
                case .notNeeded:
                    await MainActor.run {
                        coordinator?.startTabFlow()
                    }
                case .needed(let appStoreURL):
                    let alert = Alert(
                        title: "업데이트 알림",
                        message: "더 나은 서비스를 위해 업데이트 되었어요 ! 업데이트 해주세요."
                    ) {
                        AlertAction(title: "업데이트") { [weak self] in
                            self?.coordinator?.openURL(appStoreURL)
                        }
                    }
                    alertRelay.accept(alert)
                }
            } catch {
                firebaseLogger.log(name: "강제 업데이트 실패: \(error.localizedDescription)")
                await MainActor.run {
                    coordinator?.startTabFlow()
                }
            }
        }
        return .init(alert: alertRelay.asObservable())
    }
    
    private func registerDependency() async {
        let coreDataContainer = await CoreDataContainerBuilder().buildContainer()
        let firebaseLogger = FirebaseLoggerImpl()
        
        DIContainer.setLogger(firebaseLogger)
        
        DIContainer.register(type: CoreDataStorage.self, CoreDataStorageImpl(container: coreDataContainer))
        DIContainer.register(type: CoreDataService.self, DefaultCoreDataService())
        DIContainer.register(type: NetworkService.self, DefaultNetworkService())
        DIContainer.register(type: LocationService.self, DefaultLocationService())
        
        DIContainer.register(type: AsyncFavoritesRepository.self, AsyncFavoritesRepositoryImpl())
        DIContainer.register(type: FavoritesRepository.self, DefaultFavoritesRepository())
        DIContainer.register(type: BusStopArrivalInfoRepository.self, DefaultBusStopArrivalInfoRepository())
        DIContainer.register(type: StationListRepository.self, DefaultStationListRepository())
        DIContainer.register(type: RegularAlarmRepository.self, DefaultRegularAlarmRepository())
        DIContainer.register(type: LocalNotificationService.self, DefaultLocalNotificationService())
        DIContainer.register(type: RegularAlarmEditingService.self, DefaultRegularAlarmEditingService())
        DIContainer.register(
            type: VersionCheckRepository.self,
            VersionCheckRepositoryImpl(
                appStoreID: dependency.appStoreID,
                domainURL: dependency.domainURL
            )
        )
        
        DIContainer.register(type: FavoritesUseCase.self, DefaultFavoritesUseCase())
        DIContainer.register(type: RegularAlarmUseCase.self, DefaultRegularAlarmUseCase())
        DIContainer.register(type: AddRegularAlarmUseCase.self, DefaultAddRegularAlarmUseCase())
        DIContainer.register(type: SearchUseCase.self, DefaultSearchUseCase())
        DIContainer.register(type: BusStopUseCase.self, DefaultBusStopUseCase())
        DIContainer.register(type: NearMapUseCase.self, DefaultNearMapUseCase())
        DIContainer.register(type: FirebaseLogger.self, firebaseLogger)
        DIContainer.register(
            type: AppVersionCheckUseCase.self,
            VersionCheckUseCaseImpl(
                currentVersion: dependency.appVersion
            )
        )
    }
}

extension SplashViewModel {
    struct Input {
        let viewDidLoad: Single<Void>
    }
    
    struct Output {
        let alert: Observable<Alert>
    }
}
