//
//  FavoritesBusStopResponse.swift
//  Domain
//
//  Created by gnksbm on 2/25/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

public struct FavoritesBusStopResponse: CoreDataStorable, Hashable {
    public let busStopId: String
    public var busIds: [String]
    
    public init(
        busStopId: String,
        busIds: [String]
    ) {
        self.busStopId = busStopId
        self.busIds = busIds
    }
}

public extension Array<FavoritesBusStopResponse> {
    func filterDuplicated() -> Self {
        var newArr = [String: [String]]()
        forEach { favorites in
            let busIds = favorites.busIds
            if let value = newArr[favorites.busStopId] {
                let newBusIds = value + busIds
                newArr[favorites.busStopId] = newBusIds.removeDuplicated()
            } else {
                newArr[favorites.busStopId] = busIds.removeDuplicated()
            }
        }
        return newArr.map { key, value in
            FavoritesBusStopResponse(
                busStopId: key,
                busIds: value
            )
        }
    }
}
