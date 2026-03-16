//
//  Alert.swift
//  Domain
//
//  Created by gnksbm on 7/6/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

public struct Alert {
    public let title: String
    public let message: String
    public let actions: [AlertAction]
    
    public init(title: String, message: String, @TypeBuilder<AlertAction> actions: () -> [AlertAction]) {
        self.title = title
        self.message = message
        self.actions = actions()
    }
}

public struct AlertAction {
    public let title: String
    public let handler: () -> Void
    
    public init(title: String, handler: @escaping () -> Void) {
        self.title = title
        self.handler = handler
    }
}
