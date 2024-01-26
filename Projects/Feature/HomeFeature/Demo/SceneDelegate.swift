import UIKit

import FeatureDependency
import HomeFeature

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
                
        let homeCoordinator = DefaultHomeCoordinator(
            navigationController: navigationController, 
            coordinatorProvider: MockCoordinatorProvider()
        )
        homeCoordinator.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

final class MockCoordinatorProvider: CoordinatorProvider {
    func makeSearchCoordinator(
        navigationController: UINavigationController
    ) -> SearchCoordinator {
        MockCoordinator(
            testMessage: "SearchVC",
            navigationController: navigationController
        )
    }
}

final class MockCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    let testMessage: String
    var navigationController: UINavigationController
    
    init(
        testMessage: String,
        navigationController: UINavigationController
    ) {
        self.testMessage = testMessage
        self.navigationController = navigationController
    }
    
    func start() {
        let testViewController = UIViewController()
        testViewController.view.backgroundColor = .white
        testViewController.title = testMessage
        navigationController.pushViewController(
            testViewController,
            animated: true
        )
    }
}

extension MockCoordinator: SearchCoordinator {
    
}
