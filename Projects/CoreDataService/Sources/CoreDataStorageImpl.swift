//
//  CoreDataStorageImpl.swift
//  CoreDataService
//
//  Created by Logan on 6/21/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import CoreData

public final class CoreDataStorageImpl {
    enum CoreDataStorageError: Error {
        case invalidManagedObject(String)
    }
    
    private let context: NSManagedObjectContext
    private let batchSize: Int
    
    public init(container: NSPersistentContainer, batchSize: Int = 50) {
        let taskContext = container.newBackgroundContext()
        // 메모리·퍼포먼스 최적화: undo 스택을 쓰지 않으므로 불필요한 메모리 사용을 줄일 수 있습니다.
        taskContext.undoManager = nil
        // 충돌 해소 정책: mergePolicy를 명시해 두면 동시 변경 충돌 시 일관된 동작이 보장됩니다.
        taskContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        self.context = taskContext
        self.batchSize = batchSize
    }
    
    private func readManagedObject<T: CoreDataModel>(for data: T) async throws -> T.ManagedObject {
        try await context.perform { [self] in
            let request = NSFetchRequest<T.ManagedObject>(entityName: String(describing: T.ManagedObject.self))
            request.predicate = NSPredicate(format: "id == %@", data.id as CVarArg)
            request.fetchLimit = 1
            guard let first = try context.fetch(request).first else {
                throw CoreDataStorageError.invalidManagedObject(
                    "\(T.ManagedObject.self)를 찾을 수 없습니다. Data ID: \(data.id)"
                )
            }
            return first
        }
    }
    
    private func saveContext() async throws {
        try await context.perform { [self] in
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    context.rollback()
                    throw error
                }
            }
        }
    }
}

extension CoreDataStorageImpl: CoreDataStorage {
    public func create<T: CoreDataModel>(data: T) async throws {
        try await context.perform { [self] in
            let object = NSEntityDescription.insertNewObject(
                forEntityName: String(describing: T.ManagedObject.self),
                into: context
            )
            guard let coreDataManagedObject = object as? T.ManagedObject else {
                throw CoreDataStorageError.invalidManagedObject("타입 불일치: \(type(of: object)) != \(T.ManagedObject.self)")
            }
            data.sync(for: coreDataManagedObject)
        }
        try await saveContext()
    }
    
    public func read<T: CoreDataModel>(type: T.Type) async throws -> [T] {
        let managedObjects = try await context.perform { [self] in
            let request = NSFetchRequest<T.ManagedObject>(entityName: String(describing: T.ManagedObject.self))
            request.fetchLimit = 0
            request.fetchBatchSize = batchSize
            
            return try context.fetch(request)
        }
        return managedObjects.map { T.toDataModel($0) }
    }
    
    public func update<T: CoreDataModel>(data: T) async throws {
        let managedObject = try await readManagedObject(for: data)
        await context.perform {
            data.sync(for: managedObject)
        }
        try await saveContext()
    }
    
    public func delete<T: CoreDataModel>(data: T) async throws {
        let managedObject = try await readManagedObject(for: data)
        await context.perform { [self] in
            context.delete(managedObject)
        }
        try await saveContext()
    }
}
