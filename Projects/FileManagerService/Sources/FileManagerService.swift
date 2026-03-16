import Foundation

import RxSwift

public protocol FileManagerService {
    
    func save(
        data: Data,
        directoryName: String,
        fileName: String
    ) -> Observable<Void>
    
    func fetch(
        directoryName: String,
        fileName: String
    ) -> Observable<Data>
    
    func delete(
        directoryName: String,
        fileName: String
    ) -> Observable<Void>
    
    func isExist(
        directoryName: String,
        fileName: String
    ) -> Observable<Bool>
}
