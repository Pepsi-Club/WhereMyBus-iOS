import UIKit

import AlarmFeature
import Domain
import FeatureDependency

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
                
        let alarmCoordinator = DefaultRegularAlarmCoordinator(
            navigationController: navigationController,
            coordinatorProvider: MockCoordinatorProvider()
        )
        alarmCoordinator.start()
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
    func makeSearchCoordinator(navigationController: UINavigationController) -> FeatureDependency.SearchCoordinator {
        MockCoordinator(navigationController: navigationController)
    }
    
    func makeAddRegularAlarmCoordinator(navigationController: UINavigationController) -> FeatureDependency.AddRegularAlarmCoordinator {
        MockCoordinator(navigationController: navigationController)
    }
}

final class MockCoordinator
: Coordinator, SearchCoordinator ,AddRegularAlarmCoordinator {
    func start(with: RegularAlarmResponse) {
    }
    
    func startSearchFlow() {
    }
    
    func complete() {
        navigationController.popViewController(animated: true)
    }
    
    var parent: FeatureDependency.Coordinator?
    var childs: [FeatureDependency.Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.pushViewController(.init(), animated: true)
    }
    
    func finish() {
        
    }
}
