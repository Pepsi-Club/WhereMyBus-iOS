import Foundation

import Domain
import NetworkService
import Core

import RxSwift

public final class DefaultBusStationVersionRepository: BusStationVersionRepository {
    @Injected private var networkService: NetworkService
    
    @UserDefaultsWrapper(key: "busStationDataVersion", defaultValue: nil)
    private var localVersion: String?
    
    public init() { }
    
    public func fetchRemoteVersion() -> Observable<BusStationVersion> {
        let endPoint = GithubFileDownloadEndPoint(
            repo: "BusStationData",
            filePath: "bus_station_version.json"
        )
        return networkService.request(endPoint: endPoint)
            .decode(type: BusStationVersion.self, decoder: JSONDecoder())
    }
    
    public func fetchLocalVersion() -> String? {
        return localVersion
    }
    
    public func save(version: String) {
        localVersion = version
    }
}
