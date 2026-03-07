//
//  FirebaseLogger.swift
//  FirebaseInterface
//
//  Created by gnksbm on 3/30/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Foundation

public protocol FirebaseLogger {
    func log(name: String)
    func log(name: String, parameter: [String: String])
}
