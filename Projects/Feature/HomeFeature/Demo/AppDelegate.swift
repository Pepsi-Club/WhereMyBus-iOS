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
            busStops: []
        )
    )
    
    init() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.favorites.onNext(
                .init(
                    busStops: [
                        BusStopArrivalInfoResponse(busStopId: "121000214", busStopName: "길훈아파트", direction: "XX 방면", busStopNum: "02345", buses: [Domain.BusArrivalInfoResponse(routeId: "233000374", isFavorites: false, routeName: "P9602퇴", busType: "1", firstArrivalTime: "운행종료", secondArrivalTime: "운행종료", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "233000372", isFavorites: false, routeName: "P9601퇴", busType: "1", firstArrivalTime: "운행종료", secondArrivalTime: "운행종료", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "100100597", isFavorites: false, routeName: "405", busType: "1", firstArrivalTime: "출발대기", secondArrivalTime: "출발대기", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "208000031", isFavorites: false, routeName: "19", busType: "1", firstArrivalTime: "운행종료", secondArrivalTime: "운행종료", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "226000022", isFavorites: false, routeName: "G3900", busType: "1", firstArrivalTime: "출발대기", secondArrivalTime: "출발대기", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "220000012", isFavorites: false, routeName: "6", busType: "1", firstArrivalTime: "23분28초후[17번째 전]", secondArrivalTime: "출발대기", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "122000001", isFavorites: false, routeName: "4435", busType: "1", firstArrivalTime: "곧 도착", secondArrivalTime: "34분18초후[14번째 전]", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "100100246", isFavorites: false, routeName: "4432", busType: "1", firstArrivalTime: "4분3초후[2번째 전]", secondArrivalTime: "33분51초후[22번째 전]", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "122000001", isFavorites: false, routeName: "4435", busType: "1", firstArrivalTime: "운행종료", secondArrivalTime: "운행종료", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "208000006", isFavorites: false, routeName: "11-3", busType: "1", firstArrivalTime: "출발대기", secondArrivalTime: "출발대기", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "208000026", isFavorites: false, routeName: "917", busType: "1", firstArrivalTime: "출발대기", secondArrivalTime: "출발대기", isAlarmOn: false)])
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

final class MockBusStopArrivalInfoRepository: BusStopArrivalInfoRepository {
    func fetchArrivalList(
        busStopId: String, busStopName: String
    ) -> Observable<BusStopArrivalInfoResponse> {
        .create { observer in
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                observer.onNext(
                    BusStopArrivalInfoResponse(busStopId: "121000214", busStopName: "길훈아파트", direction: "XX 방면", busStopNum: "02345", buses: [Domain.BusArrivalInfoResponse(routeId: "233000374", isFavorites: false, routeName: "P9602퇴", busType: "1", firstArrivalTime: "운행종료", secondArrivalTime: "운행종료", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "233000372", isFavorites: false, routeName: "P9601퇴", busType: "1", firstArrivalTime: "운행종료", secondArrivalTime: "운행종료", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "100100597", isFavorites: false, routeName: "405", busType: "1", firstArrivalTime: "출발대기", secondArrivalTime: "출발대기", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "208000031", isFavorites: false, routeName: "19", busType: "1", firstArrivalTime: "운행종료", secondArrivalTime: "운행종료", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "226000022", isFavorites: false, routeName: "G3900", busType: "1", firstArrivalTime: "출발대기", secondArrivalTime: "출발대기", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "220000012", isFavorites: false, routeName: "6", busType: "1", firstArrivalTime: "23분28초후[17번째 전]", secondArrivalTime: "출발대기", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "122000001", isFavorites: false, routeName: "4435", busType: "1", firstArrivalTime: "곧 도착", secondArrivalTime: "34분18초후[14번째 전]", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "100100246", isFavorites: false, routeName: "4432", busType: "1", firstArrivalTime: "4분3초후[2번째 전]", secondArrivalTime: "33분51초후[22번째 전]", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "122000001", isFavorites: false, routeName: "4435", busType: "1", firstArrivalTime: "운행종료", secondArrivalTime: "운행종료", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "208000006", isFavorites: false, routeName: "11-3", busType: "1", firstArrivalTime: "출발대기", secondArrivalTime: "출발대기", isAlarmOn: false), Domain.BusArrivalInfoResponse(routeId: "208000026", isFavorites: false, routeName: "917", busType: "1", firstArrivalTime: "출발대기", secondArrivalTime: "출발대기", isAlarmOn: false)])
                )
            }
            return Disposables.create()
        }
    }
}
