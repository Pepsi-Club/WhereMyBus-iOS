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

@available(iOS 17.0, *)
struct ArrivalInfoProvider: AppIntentTimelineProvider {
    private let useCase = ArrivalInfoUseCase()

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
        let _: () = useCase.loadBusStopArrivalInfo()
        return ArrivalInfoEntry(
            date: Date(),
            configuration: configuration,
            responses: useCase.responses
        )
    }

    func timeline(
        for configuration: ArrivalInfoIntent,
        in context: Context
    ) -> Timeline<ArrivalInfoEntry> {
        let _: () = useCase.loadBusStopArrivalInfo()
        let entry = ArrivalInfoEntry(
            date: Date(),
            configuration: configuration,
            responses: useCase.responses
        )
        return Timeline(
            entries: [entry],
            policy: .atEnd
        )
    }
}
