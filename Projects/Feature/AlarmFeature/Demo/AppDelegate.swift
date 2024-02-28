import UIKit

import Core
import Domain
import DesignSystem

import RxSwift

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Appearance.setupAppearance()
        register()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func register() {
        DIContainer.register(
            type: RegularAlarmUseCase.self,
            DefaultRegularAlarmUseCase(
                regularAlarmRepository: MockRegularAlarmRepository(),
                localNotificationService: MockLocalNotificationService()
            )
        )
    }
}

final class MockRegularAlarmRepository: RegularAlarmRepository {
    func addNewAlarm() throws {
        
    }
}

final class MockLocalNotificationService: LocalNotificationService {
    var authState = BehaviorSubject<UNAuthorizationStatus>(value: .denied)
    
    func authorize() {
        
    }
    
    func fetchRegularAlarm() {
        
    }
    
    func registNewRegularAlarm(response: Domain.RegularAlarmResponse) throws {
        print(response)
    }
    
    func editRegularAlarm() throws {
        
    }
    
    func deleteRegularAlarm() throws {
        
    }
}
