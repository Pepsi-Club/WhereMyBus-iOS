import Foundation

import Domain
import FileManagerService
import NetworkService
import Core

import RxSwift

public final class DefaultGithubFileDownloadRepository: GithubFileDownloadRepository {
    @Injected private var networkService: NetworkService
    @Injected private var fileManagerService: FileManagerService
    
    public init() { }
    
    public func downloadFile(
        repo: String,
        filePath: String,
        directoryName: String,
        fileName: String
    ) -> Observable<Void> {
        let endPoint = GithubFileDownloadEndPoint(
            repo: repo,
            filePath: filePath
        )
        return networkService.request(endPoint: endPoint)
            .flatMap { [weak self] data -> Observable<Void> in
                guard let self = self else {
                    return .error(RxError.unknown) // Or a custom error
                }
                return self.fileManagerService.save(
                    data: data,
                    directoryName: directoryName,
                    fileName: fileName
                )
            }
    }
}
