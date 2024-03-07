//
//  DefaultPushNotificationService.swift
//  Data
//
//  Created by gnksbm on 3/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation
import Domain
import NetworkService

public final class DefaultPushNotificationService: PushNotificationService {
    private let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func makeNotification(payload: [String: Any]) {
    }
}
