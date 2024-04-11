//
//  DeeplinkHandler.swift
//  App
//
//  Created by gnksbm on 4/8/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

final class DeeplinkHandler {
    private let appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator?) {
        self.appCoordinator = appCoordinator
    }
    
    func handleUrl(url: URL) {
        guard let queryItems = URLComponents(
            string: url.absoluteString
        )?.queryItems
        else { return }
        queryItems.forEach { queryItem in
            switch queryItem.name {
            case "busStop":
                if let busStopId = queryItem.value {
                    appCoordinator?.startBusStopFlow(busStopId: busStopId)
                }
            default:
                break
            }
        }
    }
}
