//
//  FirebaseLoggerImpl.swift
//  ThirdPartyLibs
//
//  Created by gnksbm on 3/30/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import FirebaseAnalytics

public final class FirebaseLoggerImpl: FirebaseLogger {
    public init() { }
    
    public func log(name: String) {
        Analytics.logEvent(name, parameters: nil)
    }
    
    public func log(name: String, parameter: [String: String]) {
        Analytics.logEvent(name, parameters: parameter)
    }
}
