//
//  AppCoordinator.swift
//  YamYamPick
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import UIKit

import Core
import Domain
import FeatureDependency
import MainFeature
import BusStopFeature
import RxSwift

final class AppCoordinator: Coordinator {
    var parent: Coordinator?
    var childs: [Coordinator] = []
    var navigationController: UINavigationController
    public var coordinatorType: CoordinatorType = .app
    private let coordinatorProvider = DefaultCoordinatorProvider()
    private let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        checkAndDownloadBusStationList()
        
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            coordinatorProvider: coordinatorProvider
        )
        childs.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
    func startBusStopFlow(busStopId: String) {
        let busStopCoordinator = DefaultBusStopCoordinator(
            parent: self,
            navigationController: navigationController,
            busStopId: busStopId,
            coordinatorProvider: coordinatorProvider,
            flow: .fromHome
        )
        childs.append(busStopCoordinator)
        busStopCoordinator.start()
    }
    
    private func checkAndDownloadBusStationList() {
        @Injected var useCase: UpdateBusStationListUseCase
        
        useCase.execute()
            .subscribe(
                onError: { error in
                    print("🚏❌ bus_station_list.json 업데이트 실패: \(error)")
                },
                onCompleted: {
                    print("🚏✅ bus_station_list.json 업데이트 확인 및 처리 완료")
                }
            )
            .disposed(by: disposeBag)
    }
}
