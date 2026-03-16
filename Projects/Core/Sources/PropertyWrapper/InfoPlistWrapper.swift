//
//  InfoPlistWrapper.swift
//  Core
//
//  Created by gnksbm on 7/6/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Foundation

@propertyWrapper
public struct InfoPlistWrapper<T: InfoPlistLoadable> {
    private let key: String
    private let defaultValue: T
    
    public var wrappedValue: T {
        T.init(rawValue: Bundle.main.object(forInfoDictionaryKey: key)) ?? defaultValue
    }
    
    public init(
        key: String,
        defaultValue: T
    ) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

extension Optional: InfoPlistLoadable where Wrapped: InfoPlistLoadable {
    public init?(rawValue: Any?) {
        if let value = Wrapped(rawValue: rawValue) {
            self = .some(value)
        } else {
            self = .none
        }
    }
}

public extension InfoPlistWrapper {
    init<Wrapped: InfoPlistLoadable>(key: String) where T == Wrapped? {
        self.init(key: key, defaultValue: nil)
    }
}

public protocol InfoPlistLoadable {
    init?(rawValue: Any?)
}

extension String: InfoPlistLoadable {
    public init?(rawValue: Any?) {
        if let string = rawValue as? String {
            self = string
        } else {
            return nil
        }
    }
}

extension Int: InfoPlistLoadable {
    public init?(rawValue: Any?) {
        if let number = rawValue as? NSNumber {
            self = number.intValue
        } else if let string = rawValue as? String, let intVal = Int(string) {
            self = intVal
        } else {
            return nil
        }
    }
}

extension Double: InfoPlistLoadable {
    public init?(rawValue: Any?) {
        if let number = rawValue as? NSNumber {
            self = number.doubleValue
        } else if let string = rawValue as? String, let doubleVal = Double(string) {
            self = doubleVal
        } else {
            return nil
        }
    }
}

extension Bool: InfoPlistLoadable {
    public init?(rawValue: Any?) {
        if let bool = rawValue as? Bool {
            self = bool
        } else if let string = rawValue as? String {
            switch string.lowercased() {
            case "true", "yes", "1":
                self = true
            case "false", "no", "0":
                self = false
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}

extension Array: InfoPlistLoadable where Element: InfoPlistLoadable {
    public init?(rawValue: Any?) {
        guard let rawArray = rawValue as? [Any] else {
            return nil
        }
        var result: [Element] = []
        for element in rawArray {
            if let value = Element(rawValue: element) {
                result.append(value)
            } else {
                return nil
            }
        }
        self = result
    }
}

extension Dictionary: InfoPlistLoadable where Key == String, Value: InfoPlistLoadable {
    public init?(rawValue: Any?) {
        guard let rawDict = rawValue as? [String: Any] else {
            return nil
        }
        var result: [String: Value] = [:]
        for (key, value) in rawDict {
            if let v = Value(rawValue: value) {
                result[key] = v
            } else {
                return nil
            }
        }
        self = result
    }
}
