//
//  NearByStopWidget.swift
//  Widget
//
//  Created by gnksbm on 4/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import SwiftUI
import WidgetKit

struct NearByStopWidget: Widget {
    private let kind = "NearByStop"
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: NearByStopProvider()
        ) { entry in
            NearByStopView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
    }
}
