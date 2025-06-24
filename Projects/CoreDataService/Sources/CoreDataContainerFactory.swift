//
//  CoreDataContainerFactory.swift
//  CoreDataService
//
//  Created by Logan on 6/21/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import CoreData
import CloudKit

public final class CoreDataContainerFactory {
    private enum Constants {
        static let fileName: String = "Model"
        static let appGroupName: String = "group.Pepsi-Club.WhereMyBus"
        static let containerIdentifier: String = "iCloud.Pepsi-Club.WhereMyBus"
    }
    
    // 에러가 방출될 때 처리 방식을 고민해야 한다.
    // 1. appGroupStoreUrl, 2. CKContainer.default().accountStatus(), 3. loadPersistentStores
    public func buildContainer() async -> NSPersistentContainer {
        let container: NSPersistentContainer = await {
            let container: NSPersistentContainer
            let appGroupStoreUrl = FileManager.default
                .containerURL(forSecurityApplicationGroupIdentifier: Constants.appGroupName)?
                .appendingPathComponent("\(Constants.fileName).sqlite") ?? URL(filePath: "")
            let persistentStoreDescription = NSPersistentStoreDescription(url: appGroupStoreUrl)
            if await CKContainer.shouldUseCloudKit {
                container = NSPersistentCloudKitContainer(name: Constants.fileName)
                persistentStoreDescription.cloudKitContainerOptions = .init(containerIdentifier: Constants.containerIdentifier)
            } else {
                container = NSPersistentContainer(name: Constants.fileName)
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.persistentStoreDescriptions = [persistentStoreDescription]
            return container
        }()
        let _: Void = await withCheckedContinuation { continuation in
            container.loadPersistentStores { _, error in
                continuation.resume()
            }
        }
        return container
    }
}

extension CKContainer {
    static var shouldUseCloudKit: Bool {
        get async {
            let status = try? await CKContainer.default().accountStatus()
            return status == .available
        }
    }
}
