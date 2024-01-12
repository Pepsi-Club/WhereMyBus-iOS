//
//  DIContainer.swift
//  Core
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import Foundation

public final class DIContainer {
    static var storage: [String: Any] = [:]
    
    private init() { }
    
    public static func register<T>(type: T.Type, _ object: T) {
        storage["\(type)"] = object
    }
    
    static func resolve<T>(type: T.Type) -> T {
        guard let object = storage["\(type)"] as? T else {
            fatalError("register 되지 않은 객체 호출: \(type)")
        }
        return object
    }
}
