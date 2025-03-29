//
//  DIContainer.swift
//  Core
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import Foundation

import FirebaseAnalytics

public enum DIContainer {
    private static var storage: [String: Any] = [:]
    
    public static func register<Dependency>(
        type: Dependency.Type,
        _ instance: Dependency
    ) {
        storage[String(describing: Dependency.self)] = instance
    }
    
    static func resolve<Dependency>(type: Dependency.Type) -> Dependency {
        let typeName = String(describing: Dependency.self)
        guard let savedInstance = storage[typeName] as? Dependency else {
            Analytics.logEvent("DependencyCrash", parameters: ["type": typeName])
            fatalError("register 되지 않은 객체 호출: \(type)")
        }
        return savedInstance
    }
}
