//
//  BusOptionProvider.swift
//  AppUITests
//
//  Created by gnksbm on 4/13/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import AppIntents

import CoreDataService
import Domain

struct BusOptionProvider: DynamicOptionsProvider {
    let coreDataService = DefaultCoreDataService()
    func defaultResult() async -> String? {
        ""
    }
    
    func results() async throws -> [String] {
        let responses = try coreDataService.fetch(
            type: FavoritesBusStopResponse.self
        )
        return responses.flatMap { $0.busIds }
//        []
    }
}
