//
//  ArrivalInfoProvider.swift
//  AppUITests
//
//  Created by gnksbm on 4/4/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import SwiftUI
import WidgetKit

import Core
import Domain
import NetworkService
import CoreDataService

@available(iOS 17.0, *)
struct ArrivalInfoProvider: AppIntentTimelineProvider {
    private let network: ArrivalNetworkService
    
    func placeholder(in context: Context) -> ArrivalInfoEntry {
        ArrivalInfoEntry(
            date: Date(),
            configuration: ArrivalInfoIntent(),
            responses: []
        )
    }

    func snapshot(
        for configuration: ArrivalInfoIntent,
        in context: Context
    ) -> ArrivalInfoEntry {
        //미리보기 데이터
    }

    func timeline(
        for configuration: ArrivalInfoIntent,
        in context: Context
    ) -> Timeline<ArrivalInfoEntry> {
        let entry = ArrivalInfoEntry(
            date: Date(),
            configuration: configuration,
            responses: network.fetchArrivalList(busStopId: <#T##String#>)
        )
        return Timeline(
            entries: [entry],
            policy: .atEnd
        )
    }
}
