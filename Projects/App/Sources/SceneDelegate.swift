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
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var deeplinkHandler: DeeplinkHandler?
    
    let disposeBag = DisposeBag()
    
    @Injected(VersionCheckUseCase.self) var useCase: VersionCheckUseCase

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
        checkAndUpdateIfNeeded()
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
        guard let appId = Bundle.main.object(
            forInfoDictionaryKey: "APPSTORE_ID"
        ) as? String
        else { return }
        
        useCase.fetchAppStoreURL(appId: appId)
            .subscribe { [weak self] str in
                guard let self,
                      let urlString = str
                else { return }
                self.showUpdateAlert(with: urlString)
            } onFailure: { error in
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
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.window?.rootViewController?.present(alert, animated: true)
        }
    }
    
    private func openAppStore(_ str: String) {
        guard let url = URL(string: str) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

