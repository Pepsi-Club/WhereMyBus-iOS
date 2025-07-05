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

final class SceneDelegate: UIResponder,
                           UIWindowSceneDelegate,
                           AppCoordinatorDependency {
    @Injected private var useCase: VersionCheckUseCase
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var deeplinkHandler: DeeplinkHandler?
    
    let _sceneWillEnterForeground = AsyncStream<UIScene>.makeStream(bufferingPolicy: .bufferingNewest(1))
    var sceneWillEnterForeground: AsyncStream<UIScene> {
        _sceneWillEnterForeground.stream
    }
    
    var appVersion: AppVersionInfoResponse {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String
        else { return .defaultVersion }
        
        let splitedVersion = version.split(separator: ".").compactMap { Int($0) }
        
        return AppVersionInfoResponse(
            major: splitedVersion[0],
            minor: splitedVersion[1],
            patch: splitedVersion[2]
        )
    }
    
    var appStoreID: String {
        Bundle.main.object(forInfoDictionaryKey: "APPSTORE_ID") as? String ?? ""
    }
    
    var domainURL: String {
        Bundle.main.object(forInfoDictionaryKey: "DOMAIN_URL") as? String ?? ""
    }

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

