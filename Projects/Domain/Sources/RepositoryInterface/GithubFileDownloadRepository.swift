import Foundation

import RxSwift

public protocol GithubFileDownloadRepository {
    func downloadFile(
        repo: String,
        filePath: String,
        directoryName: String,
        fileName: String
    ) -> Observable<Void>
}
