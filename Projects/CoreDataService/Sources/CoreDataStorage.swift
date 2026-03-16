//
//  CoreDataStorage.swift
//  CoreDataService
//
//  Created by Logan on 6/21/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

public protocol CoreDataStorage {
    func create<T: CoreDataRepresentable>(data: T) async throws
    func read<T: CoreDataRepresentable>(type: T.Type) async throws -> [T]
    func update<T: CoreDataRepresentable>(data: T) async throws
    func delete<T: CoreDataRepresentable>(data: T) async throws
}
