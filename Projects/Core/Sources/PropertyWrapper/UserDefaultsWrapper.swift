//
//  UserDefaultsWrapper.swift
//  Core
//
//  Created by gnksbm on 4/18/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefaultsWrapper<T: Codable> {
    private let key: String
    private let defaultValue: T
    private let dataBase: UserDefaults
    
    public var wrappedValue: T {
        get {
            guard let data = dataBase.value(forKey: key) as? Data,
                  let value = try? data.decode(type: T.self)
            else { return defaultValue }
            return value
        }
        set {
            guard let data = newValue.encode()
            else { return }
            dataBase.setValue(data, forKey: key)
        }
    }
    
    public init(
        key: String,
        defaultValue: T,
        kind: UserDefaultsKind = .appGroup
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.dataBase = kind.dataBase
        if kind == .appGroup,
           !UserDefaults.standard.bool(forKey: "legacyRemoved") {
            UserDefaults.standard.set(true, forKey: "legacyRemoved")
            kind.dataBase.removePersistentDomain(
                forName: "group.Pepsi-Club.WhereMyBus"
            )
        }
    }
}

public enum UserDefaultsKind {
    case appGroup, standard
    
    var dataBase: UserDefaults {
        switch self {
        case .appGroup:
            return .appGroup
        case .standard:
            return .standard
        }
    }
}
