//
//  WMBEntry.swift
//  AppUITests
//
//  Created by gnksbm on 4/4/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import WidgetKit
import Domain

struct WMBEntry: TimelineEntry {
    let date: Date
    let responses: [BusStopArrivalInfoResponse]
    
    init(
        date: Date,
        responses: [BusStopArrivalInfoResponse] = []
    ) {
        self.date = date
        self.responses = responses
    }
}
