//
//  SceneDelegate.swift
//  AppStore
//
//  Created by gnksbm on 2023/11/15.
//  Copyright © 2023 gnksbm All rights reserved.
//

import UIKit

import Core
import NetworkService
import Domain
import Data

import RxSwift

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    @Injected private var useCase: VersionCheckUseCase
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var deeplinkHandler: DeeplinkHandler?
    
    let disposeBag = DisposeBag()
    

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        navigationController.view.backgroundColor = .systemBackground

        window?.rootViewController = navigationController
        appCoordinator = AppCoordinator(
            navigationController: navigationController
        )
        appCoordinator?.start()
        window?.makeKeyAndVisible()
        // 앱 진입할 때 확인
        deeplinkHandler = .init(appCoordinator: appCoordinator)
        if let url = connectionOptions.urlContexts.first?.url {
            deeplinkHandler?.handleUrl(url: url)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    /// 앱이 Foreground로 전환될때 실행될 함수
    func sceneWillEnterForeground(_ scene: UIScene) {
        checkAndUpdateIfNeeded()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        if let url = URLContexts.first?.url {
            deeplinkHandler?.handleUrl(url: url)
        }
    }
    
    private func checkAndUpdateIfNeeded() {
        useCase.fetchAppStoreURL()
            .subscribe(with: self) { owner, str in
                guard let str else { return }
                owner.showUpdateAlert(with: str)
            } onFailure: { _, error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    private func showUpdateAlert(with urlString: String) {
        let alert = UIAlertController(
            title: "업데이트 알림",
            message: "더 나은 서비스를 위해 업데이트 되었어요 ! 업데이트 해주세요.",
            preferredStyle: .alert
        )
        
        let alertAction = UIAlertAction(
            title: "업데이트",
            style: .default
        ) { [weak self] _ in
            guard let self else { return }
            
            openAppStore(urlString)
        }
        
        alert.addAction(alertAction)
        
        Task { @MainActor in
            window?.rootViewController?.present(alert, animated: true)
        }
    }
    
    private func openAppStore(_ str: String) {
        guard let url = URL(string: str) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

