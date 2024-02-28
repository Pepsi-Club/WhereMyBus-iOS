import UIKit

import Core
import Domain

import RxSwift

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // register 함수만들고 앱 실행될때 함수 호출될 수 있게!
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
            type: BusStopUseCase.self,
            DefaultBusStopUseCase(
                busStopArrivalInfoRepository: MockBusStopArrivalInfoRepository(),
                favoritesRepository: MockFavoritesRepository()
            )
        )
    }
}

final class MockBusStopArrivalInfoRepository: BusStopArrivalInfoRepository {
    func fetchArrivalList(
        busStopId: String,
        busStopName: String
    ) -> Observable<BusStopArrivalInfoResponse> {
        .create { observer in
            observer.onNext(
                BusStopArrivalInfoResponse(
                    busStopId: "122000666",
                    busStopName: "강남구보건소",
                    direction: "강남구청역 방면",
                    busStopNum: "23290",
                    buses: [
                        BusArrivalInfoResponse(
                            routeId: "124000038",
                            isFavorites: false,
                            routeName: "342",
                            busType: "3",
                            firstArrivalTime: "7분[3정거장전]",
                            secondArrivalTime: "18분[9정거장전]",
                            isAlarmOn: false),
                        BusArrivalInfoResponse(
                            routeId: "124000039",
                            isFavorites: false,
                            routeName: "3412",
                            busType: "4",
                            firstArrivalTime: "7분[3정거장전]",
                            secondArrivalTime: "18분[9정거장전]",
                            isAlarmOn: false),
                        BusArrivalInfoResponse(
                            routeId: "",
                            isFavorites: false,
                            routeName: "471",
                            busType: "3",
                            firstArrivalTime: "7분[3정거장전]",
                            secondArrivalTime: "18분[9정거장전]",
                            isAlarmOn: false),
                        BusArrivalInfoResponse(
                            routeId: "",
                            isFavorites: false,
                            routeName: "3412",
                            busType: "4",
                            firstArrivalTime: "7분[2정거장전]",
                            secondArrivalTime: "18분[9정거장전]",
                            isAlarmOn: false),
                        BusArrivalInfoResponse(
                            routeId: "",
                            isFavorites: false,
                            routeName: "471",
                            busType: "3",
                            firstArrivalTime: "5분[2정거장전]",
                            secondArrivalTime: "18분[9정거장전]",
                            isAlarmOn: false),
                        BusArrivalInfoResponse(
                            routeId: "",
                            isFavorites: false,
                            routeName: "471",
                            busType: "3",
                            firstArrivalTime: "3분[1정거장전]",
                            secondArrivalTime: "18분[9정거장전]",
                            isAlarmOn: false),
                        BusArrivalInfoResponse(
                            routeId: "",
                            isFavorites: false,
                            routeName: "541",
                            busType: "3",
                            firstArrivalTime: "7분[3정거장전]",
                            secondArrivalTime: "18분[9정거장전]",
                            isAlarmOn: false),
                        BusArrivalInfoResponse(
                            routeId: "",
                            isFavorites: false,
                            routeName: "4001-1",
                            busType: "1",
                            firstArrivalTime: "18분[2정거장전]",
                            secondArrivalTime: "35분[3정거장전]",
                            isAlarmOn: false),
                    ]
                )
            )
            return Disposables.create()
        }
    }
}

final class MockFavoritesRepository: FavoritesRepository {
    var favorites = BehaviorSubject<FavoritesResponse>(
        value: .init(
            busStops: []
        )
    )
    
    init() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.favorites.onNext(
                .init(
                    busStops: [
                        BusStopArrivalInfoResponse(
                            busStopId: "122000666",
                            busStopName: "강남구보건소",
                            direction: "강남구청역 방면",
                            busStopNum: "23290",
                            buses: [
                                BusArrivalInfoResponse(
                                    routeId: "124000038",
                                    isFavorites: false,
                                    routeName: "342",
                                    busType: "3",
                                    firstArrivalTime: "7분[3정거장전]",
                                    secondArrivalTime: "18분[9정거장전]",
                                    isAlarmOn: false),
                                BusArrivalInfoResponse(
                                    routeId: "124000039",
                                    isFavorites: false,
                                    routeName: "3412",
                                    busType: "4",
                                    firstArrivalTime: "7분[3정거장전]",
                                    secondArrivalTime: "18분[9정거장전]",
                                    isAlarmOn: false),
                            ]
                        ),
                        BusStopArrivalInfoResponse(
                            busStopId: "122000692",
                            busStopName: "래미안강남힐즈",
                            direction: "못골마을 방면",
                            busStopNum: "23446",
                            buses: [
                                BusArrivalInfoResponse(
                                    routeId: "100100209",
                                    isFavorites: false,
                                    routeName: "강남03",
                                    busType: "0",
                                    firstArrivalTime: "12분27초후[5번째 전]",
                                    secondArrivalTime: "26분53초후[12번째 전]",
                                    isAlarmOn: false)
                            ]
                        ),
                    ]
                )
            )
        }
    }
    
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
