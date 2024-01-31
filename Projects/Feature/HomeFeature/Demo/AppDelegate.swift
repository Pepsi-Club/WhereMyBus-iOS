import UIKit

import Core
import Domain

import RxSwift

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
            type: FavoritesUseCase.self,
            DefaultFavoritesUseCase(
                busStopArrivalInfoRepository: MockBusStopArrivalInfoRepository(), 
                favoritesRepository: MockFavoritesRepository()
            )
        )
    }
}

final class MockFavoritesRepository: FavoritesRepository {
    var favorites = BehaviorSubject<FavoritesResponse>(
        value: .init(
            busStops: [
                .init(
                    busStopId: "테스트",
                    busStopName: "테스트",
                    direction: "테스트",
                    buses: [
                        .init(
                            routeId: "테스트",
                            isFavorites: false,
                            routeName: "테스트",
                            busType: "테스트",
                            firstArrivalTime: "테스트",
                            secondArrivalTime: "테스트",
                            isAlarmOn: false
                        )
                    ]
                )
            ]
        )
    )
    
    func addRoute(
        busStopId: String, 
        busStopName: String,
        direction: String,
        bus: BusArrivalInfoResponse
    ) {
        
    }
    
    func removeRoute(
        busStopId: String,
        bus: BusArrivalInfoResponse
    ) {
        
    }
}

final class MockBusStopArrivalInfoRepository: BusStopArrivalInfoRepository {
    var responses: BehaviorSubject<[RouteArrivalInfo]> = .init(value: [
        .init(
            routeName: "테스트",
            firstArrivalTime: "테스트",
            firstArrivalRemaining: "테스트",
            secondArrivalTime: "테스트",
            secondArrivalRemaining: "테스트"
        )
    ])
    
    var arrivalInfoResponse: PublishSubject<ArrivalInfoResponse> = .init()
    
    func fetchArrivalList(
        busStopId: String, busStopName: String
    ) -> Observable<BusStopArrivalInfoResponse> {
        .create { observer in
            observer.onNext(
                .init(
                    busStopId: "테스트",
                    busStopName: "테스트",
                    direction: "테스트",
                    buses: [
                        .init(
                            routeId: "테스트",
                            isFavorites: false,
                            routeName: "테스트",
                            busType: "테스트",
                            firstArrivalTime: "테스트",
                            secondArrivalTime: "테스트",
                            isAlarmOn: false
                        )
                    ]
                )
            )
            return Disposables.create()
        }
    }
}
