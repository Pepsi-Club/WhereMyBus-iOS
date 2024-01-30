//
//  FavoritesSection.swift
//  Domain
//
//  Created by gnksbm on 1/26/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxDataSources

public struct FavoritesSection {
    public let busStopName: String
    public let busStopDirection: String
    public var items: [RouteArrivalInfo]
}

extension FavoritesSection: SectionModelType {
    public typealias Item = RouteArrivalInfo
    
    public init(
        original: FavoritesSection,
        items: [RouteArrivalInfo]
    ) {
        self = original
        self.items = items
    }
}
