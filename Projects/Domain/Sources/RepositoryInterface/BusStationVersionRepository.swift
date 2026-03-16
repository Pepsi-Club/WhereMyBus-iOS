import Foundation

import RxSwift

public protocol BusStationVersionRepository {
    /// 원격 저장소에서 최신 버스 정류장 데이터의 버전 정보를 가져옵니다.
    func fetchRemoteVersion() -> Observable<BusStationVersion>
    
    /// 로컬에 저장된 버스 정류장 데이터의 버전 정보를 가져옵니다.
    func fetchLocalVersion() -> String?
    
    /// 로컬에 새로운 버스 정류장 데이터의 버전 정보를 저장합니다.
    func save(version: String)
}
