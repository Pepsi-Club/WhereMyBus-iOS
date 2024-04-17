//
//  DefaultCoreDataService.swift
//  CoreDataService
//
//  Created by gnksbm on 2/17/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

import Core

import RxSwift

public final class DefaultCoreDataService: CoreDataService {
    private var container: NSPersistentContainer
    
    public let storeStatus = BehaviorSubject<StoreStatus>(value: .loading)
    
    private let ckContainer = CKContainer.default()
    @UserDefaultsWrapper(
        key: "coreDataMigrationStatus",
        defaultValue: CoreDataMigrationStatus.applicationSupport
    )
    private var migrationStatus
    private let fileName = "Model"
    private let appGroupName = "group.Pepsi-Club.WhereMyBus"
    
    public init() {
        container = NSPersistentContainer(name: fileName)
        do {
            try configureContainer()
        } catch {
            #if DEBUG
            print(error.localizedDescription)
            #endif
        }
    }
    
    private func configureContainer() throws {
        Task {
            let accountStatus = try await ckContainer.accountStatus()
            switch accountStatus {
            case .available:
                container = NSPersistentCloudKitContainer(name: fileName)
            default:
                break
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
            switch migrationStatus {
            case .applicationSupport:
                break
            case .appGroup:
                container.persistentStoreDescriptions = [
                    .init(url: appGroupStoreUrl)
                ]
            }
            #if DEBUG
            print("💾 \(migrationStatus)")
            #endif
            loadStore()
        }
    }
    
    private func loadStore() {
        container.loadPersistentStores { [weak self] desc, error in
            guard let self else { return }
            if let error {
                #if DEBUG
                print(error.localizedDescription)
                #endif
            }
            if let storeUrl = desc.url {
                #if DEBUG
                print(
                    "💾 Load된 SQLite URL: \(storeUrl)"
                )
                #endif
            }
            switch self.migrationStatus {
            case .applicationSupport:
                DispatchQueue.global(qos: .userInitiated).async {
                    self.migrateStore()
                    self.storeStatus.onNext(.loaded)
                    #if DEBUG
                    print("💾 저장소 마이그레이션 완료")
                    #endif
                }
            case .appGroup:
                self.storeStatus.onNext(.loaded)
                #if DEBUG
                print("💾 저장소 마이그레이션 없음")
                #endif
            }
        }
    }
    
    public func fetch<T: CoreDataStorable>(
        type: T.Type
    ) -> Observable<[T]> {
        Observable.create { observer in
            do {
                let result = try self.fetchMO(type: type)
                    .compactMap { $0 as? CoreDataModelObject }
                    .compactMap { $0.toDomain as? T }
                observer.onNext(result)
                observer.onCompleted()
                return Disposables.create()
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
    }
    
    public func fetch<T: CoreDataStorable>(type: T.Type) throws -> [T] {
        do {
            return try fetchMO(type: type)
                .compactMap { $0 as? CoreDataModelObject }
                .compactMap { $0.toDomain as? T }
        } catch {
            throw error
        }
    }
    
    public func save<T: CoreDataStorable>(data: T) throws {
        let object = NSEntityDescription.insertNewObject(
            forEntityName: "\(type(of: data))MO",
            into: container.viewContext
        )
        let mirror = Mirror(reflecting: data)
        mirror.children.forEach { key, value in
            guard let key,
                  let propertyName = String(describing: key)
                .split(separator: ".")
                .last
            else { return }
            object.setValue(value, forKey: String(propertyName))
        }
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            throw error
        }
    }

    public func saveUniqueData<T: CoreDataStorable, U: Equatable>(
        data: T,
        uniqueKeyPath: KeyPath<T, U>
    ) throws {
        let isUnique = try isUnique(
            type: type(of: data),
            uniqueKeyPath: uniqueKeyPath,
            uniqueValue: data[keyPath: uniqueKeyPath]
        )
        if isUnique {
            try save(data: data)
        }
    }
    
    public func update<T: CoreDataStorable, U: Equatable>(
        data: T,
        uniqueKeyPath: KeyPath<T, U>
    ) throws {
        let fetchedMo = try fetchMO(type: type(of: data))
        let uniqueValue = data[keyPath: uniqueKeyPath]
        let object = fetchedMo.first { object in
            guard let fetchedValue = object.value(
                forKey: uniqueKeyPath.propertyName
            ) as? U
            else { return false }
            return fetchedValue == uniqueValue
        }
        let mirror = Mirror(reflecting: data)
        mirror.children.forEach { key, value in
            guard let key,
                  let propertyName = String(describing: key)
                .split(separator: ".")
                .last
            else { return }
            object?.setValue(
                value,
                forKey: String(propertyName)
            )
        }
        if container.viewContext.hasChanges {
            try container.viewContext.save()
        }
    }
    
    public func delete<T: CoreDataStorable, U>(
        data: T,
        uniqueKeyPath: KeyPath<T, U>
    ) throws where U: Equatable {
        let fetchedMo = try fetchMO(type: type(of: data))
        guard let object = fetchedMo.first(where: { object in
            guard let value = object.value(
                forKey: uniqueKeyPath.propertyName
            ) as? U
            else { return false }
            return value == data[keyPath: uniqueKeyPath]
        })
        else { return }
        container.viewContext.delete(object)
        if container.viewContext.hasChanges {
            try container.viewContext.save()
        }
    }
    
    public func isUnique<T: CoreDataStorable, U: Equatable>(
        type: T.Type,
        uniqueKeyPath: KeyPath<T, U>,
        uniqueValue: U
    ) throws -> Bool {
        let fetchedMO = try fetchMO(type: type)
        return !fetchedMO.contains { object in
            guard let uniqueProperty = object.value(
                forKey: uniqueKeyPath.propertyName
            ) as? U
            else { return false }
            return uniqueProperty == uniqueValue
        }
    }
    
    private func fetchMO<T: CoreDataStorable>(
        type: T.Type
    ) throws -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(
            entityName: "\(type)MO"
        )
        return try container.viewContext.fetch(request)
    }
}
// MARK: 마이그레이션
extension DefaultCoreDataService {
    var appGroupStoreUrl: URL {
        guard let appGroupStoreUrl = FileManager.default
            .containerURL(
                forSecurityApplicationGroupIdentifier: appGroupName
            )?
            .appendingPathComponent(
                "\(fileName).sqlite"
            )
        else {
            #if DEBUG
            print("💾 AppGroup 디렉토리 URL 찾기 실패")
            #endif
            return URL(filePath: "")
        }
        return appGroupStoreUrl
    }
    
    var legacyStoreUrl: URL {
        guard let legacyStoreUrl = FileManager.default
            .urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
            )
            .first?
            .appendingPathComponent(
                "\(fileName).sqlite"
            )
        else {
            #if DEBUG
            print("💾 레거시 디렉토리 URL 찾기 실패")
            #endif
            return URL(filePath: "")
        }
        return legacyStoreUrl
    }
    
    private func migrateStore() {
        let fileManager = FileManager.default
        let coordinator = container.persistentStoreCoordinator
        guard let legacyStore = coordinator.persistentStore(for: legacyStoreUrl)
        else { return }
        do {
            _ = try coordinator.migratePersistentStore(
                legacyStore,
                to: appGroupStoreUrl,
                type: .sqlite
            )
            #if DEBUG
            print(
                "💾 마이그레이션 성공"
            )
            #endif
            migrationStatus = .appGroup
            do {
                try fileManager.removeItem(atPath: legacyStoreUrl.path)
            } catch {
                #if DEBUG
                print(
                    "💾 레거시 제거 실패",
                    "💾 \(error.localizedDescription)",
                    separator: "\n"
                )
                #endif
            }
        } catch {
            #if DEBUG
            print(
                "💾 마이그레이션 실패",
                "💾 \(error.localizedDescription)",
                separator: "\n"
            )
            #endif
        }
    }
}
