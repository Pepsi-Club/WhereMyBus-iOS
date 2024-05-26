//
//  SceneDelegate.swift
//  AppStore
//
//  Created by gnksbm on 2023/11/15.
//  Copyright © 2023 gnksbm All rights reserved.
//

import UIKit

import NetworkService
import Domain
import Data

import RxSwift

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var deeplinkHandler: DeeplinkHandler?

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
        
        Task {
            await self.checkAndUpdateIfNeeded()
        }
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
        Task {
            await self.checkAndUpdateIfNeeded()
        }
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
    
    private func checkAndUpdateIfNeeded() async {
        guard let marketingVersion = await AppStoreCheck.latestVersion()
        else { return }
        
        /// 현재 기기 버전
        let currentProjectVersion = String.getCurrentVersion()
        
        /// .을 기준으로 나눔
        let splitMarketingVersion = marketingVersion.split(separator: ".").map { $0 }
        let splitCurrentProjectVersion = currentProjectVersion.split(separator: ".").map { $0 }
        
        if splitCurrentProjectVersion.count > 0 && splitMarketingVersion.count > 0 {
            // Major 버전만을 비교
            if splitCurrentProjectVersion[0] < splitMarketingVersion[0] {
                self.showUpdateAlert(version: marketingVersion)
            } else {
                print("현재 최신 버전입니다.")
            }
            
        }
    }
    
    private func showUpdateAlert(version: String) {
        let alert = UIAlertController(
            title: "업데이트 알림",
            message: "더 나은 서비스를 위해 업데이트 되었어요 ! 업데이트 해주세요.",
            preferredStyle: .alert
        )
        
        let alertAction = UIAlertAction(
            title: "업데이트",
            style: .default) { _ in
                AppStoreCheck.openAppStore()
            }
        
        alert.addAction(alertAction)
        window?.rootViewController?.present(alert, animated: true)
        
    }
}

