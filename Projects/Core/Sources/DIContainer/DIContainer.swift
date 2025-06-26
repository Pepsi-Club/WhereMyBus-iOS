//
//  DIContainer.swift
//  Core
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import Foundation

import FirebaseInterface

public enum DIContainer {
    private static var storage: [String: Any] = [:]
    private static var lock: NSLock = .init()
    private static var firebaseLogger: FirebaseLogger?
    public static func setLogger(_ logger: FirebaseLogger) {
        firebaseLogger = logger
    }
    
    public static func register<Dependency>(
        type: Dependency.Type,
        _ instance: Dependency
    ) {
        lock.lock()
        defer { lock.unlock() }
        storage[String(describing: Dependency.self)] = instance
    }
    
    static func resolve<Dependency>(type: Dependency.Type) -> Dependency {
        let typeName = String(describing: Dependency.self)
        lock.lock()
        defer { lock.unlock() }
        guard let savedInstance = storage[typeName] as? Dependency else {
            firebaseLogger?.log(name: "DependencyCrash", parameter: ["type": typeName])
            fatalError("register 되지 않은 객체 호출: \(type)")
        }
        return savedInstance
    }
}
