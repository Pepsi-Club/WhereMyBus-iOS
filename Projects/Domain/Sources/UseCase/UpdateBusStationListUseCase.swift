import Foundation
import Core
import RxSwift

public protocol UpdateBusStationListUseCase {
    func execute() -> Observable<Void>
}

public final class DefaultUpdateBusStationListUseCase: UpdateBusStationListUseCase {
    @Injected private var versionRepository: BusStationVersionRepository
    @Injected private var fileDownloadRepository: GithubFileDownloadRepository
    
    public init() { }
    
    public func execute() -> Observable<Void> {
        return versionRepository.fetchRemoteVersion()
            .do(onNext: { remoteVersion in
                print("🚏 버스정류장 원격 버전 확인: \(remoteVersion.busStationVersion)")
            }, onError: { error in
                print("🚏 버스정류장 원격 버전 확인 중 에러 발생: \(error)")
            })
            .flatMap { [weak self] remoteVersion -> Observable<Void> in
                guard let self = self else { return .error(RxError.unknown) }
                
                let localVersion = self.versionRepository.fetchLocalVersion()
                print("🚏 버스정류장 로컬 버전 확인: \(localVersion ?? "기존 파일 없음")")
                
                let needsUpdate = localVersion != remoteVersion.busStationVersion
                print("🚏 [버스정류장 버전 비교]")
                print("로컬: \(localVersion ?? "파일 없음")")
                print("원격: \(remoteVersion.busStationVersion)")
                
                if needsUpdate {
                    return self.downloadAndSave(
                        newVersion: remoteVersion.busStationVersion
                    )
                } else {
                    print("🚏 버스정류장 정보가 이미 최신 버전입니다.")
                    return .just(())
                }
            }
    }
    
    private func downloadAndSave(newVersion: String) -> Observable<Void> {
        print("🚏 downloadAndSave 호출. bus_station_list.json 다운로드")
        return fileDownloadRepository.downloadFile(
            repo: "BusStationData",
            filePath: "bus_station_list.json",
            directoryName: "jsons",
            fileName: "bus_station_list.json"
        )
        .do(onNext: { _ in
            
            self.versionRepository.save(version: newVersion)
            print("🚏 로컬에 최신 버스정류장 정보 저장")
        }, onError: { error in
            print("🚏 파일 다운로드 중 에러 발생: \(error)")
        })
    }
}
