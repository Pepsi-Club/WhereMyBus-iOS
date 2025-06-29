//
//  CoreDataStorage.swift
//  CoreDataService
//
//  Created by Logan on 6/21/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

public protocol CoreDataStorage {
    func create<T: CoreDataModel>(data: T) async throws
    func read<T: CoreDataModel>(type: T.Type) async throws -> [T]
    func update<T: CoreDataModel>(data: T) async throws
    func delete<T: CoreDataModel>(data: T) async throws
}
