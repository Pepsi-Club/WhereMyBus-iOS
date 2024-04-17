//
//  ArrivalInfoIntent.swift
//  Widget
//
//  Created by gnksbm on 4/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import WidgetKit
import AppIntents

@available(iOS 17.0, *)
struct ArrivalInfoIntent: WidgetConfigurationIntent, AppIntent {
    static var title: LocalizedStringResource = "Configuration"

    @Parameter(title: "정류장", optionsProvider: BusStopOptionProvider())
    var busStop: String
    @Parameter(title: "버스", optionsProvider: BusOptionProvider())
    var bus: String
}
