import Foundation

import Domain
import RxSwift

public final class DefaultFileManagerService: FileManagerService {
    
    private let fileManager: FileManager
    
    public init(
        fileManager: FileManager = .default
    ) {
        self.fileManager = fileManager
    }
    
    public func save(
        data: Data,
        directoryName: String,
        fileName: String
    ) -> Observable<Void> {
        .create { [weak self] observer in
            guard let self else {
                observer.onError(FileManagerServiceError.unknown)
                return Disposables.create()
            }
            do {
                let directoryURL = try self.getDirectoryURL(with: directoryName)
                let fileURL = directoryURL.appendingPathComponent(fileName)
                try data.write(to: fileURL)
                print(fileURL.path)
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    public func fetch(
        directoryName: String,
        fileName: String
    ) -> Observable<Data> {
        .create { [weak self] observer in
            guard let self else {
                observer.onError(FileManagerServiceError.unknown)
                return Disposables.create()
            }
            do {
                let fileURL = try self.getFileURL(
                    directoryName: directoryName,
                    fileName: fileName
                )
                let data = try Data(contentsOf: fileURL)
                observer.onNext(data)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    public func delete(
        directoryName: String,
        fileName: String
    ) -> Observable<Void> {
        .create { [weak self] observer in
            guard let self else {
                observer.onError(FileManagerServiceError.unknown)
                return Disposables.create()
            }
            do {
                let fileURL = try self.getFileURL(
                    directoryName: directoryName,
                    fileName: fileName
                )
                try self.fileManager.removeItem(at: fileURL)
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    public func isExist(
        directoryName: String,
        fileName: String
    ) -> Observable<Bool> {
        do {
            let fileURL = try getFileURL(
                directoryName: directoryName,
                fileName: fileName
            )
            return .just(fileManager.fileExists(atPath: fileURL.path))
        } catch {
            return .error(error)
        }
    }
}

private extension DefaultFileManagerService {
    func getDirectoryURL(with name: String) throws -> URL {
        let directoryURL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent(name)
        
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(
                    at: directoryURL,
                    withIntermediateDirectories: true
                )
            } catch {
                throw FileManagerServiceError.directoryCreationFailed(error)
            }
        }
        return directoryURL
    }
    
    func getFileURL(
        directoryName: String,
        fileName: String
    ) throws -> URL {
        let directoryURL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent(directoryName)
        
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw FileManagerServiceError.fileNotFound
        }
        
        return fileURL
    }
}
