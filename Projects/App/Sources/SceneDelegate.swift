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

final class SceneDelegate: UIResponder,
                           UIWindowSceneDelegate,
                           AppCoordinatorDependency {
    @Injected private var useCase: AppVersionCheckUseCase
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var deeplinkHandler: DeeplinkHandler?
    
    let _sceneWillEnterForeground = AsyncStream<UIScene>.makeStream(bufferingPolicy: .bufferingNewest(1))
    var sceneWillEnterForeground: AsyncStream<UIScene> {
        _sceneWillEnterForeground.stream
    }
    
    @InfoPlistWrapper(
        key: "CFBundleShortVersionString",
        defaultValue: .defaultVersion
    )
    var appVersion: AppVersionInfoResponse
    
    @InfoPlistWrapper(key: "APPSTORE_ID", defaultValue: "")
    var appStoreID: String
    
    @InfoPlistWrapper(key: "DOMAIN_URL", defaultValue: "")
    var domainURL: String

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
            navigationController: navigationController,
            dependency: self
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
        _sceneWillEnterForeground.continuation.yield(scene)
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
}

