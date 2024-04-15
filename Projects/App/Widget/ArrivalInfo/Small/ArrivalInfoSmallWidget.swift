//
//  ArrivalInfoSmallWidget.swift
//  WidgetExtension
//
//  Created by gnksbm on 4/4/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import WidgetKit
import SwiftUI

@available(iOS 17.0, *)
struct ArrivalInfoSmallWidget: Widget {
    let kind: String = "ArrivalInfoSmall"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ArrivalInfoIntent.self,
            provider: ArrivalInfoProvider()
        ) { entry in
            ArrivalInfoSmallView(
                entry: entry
            )
        }
        .supportedFamilies([.systemMedium])
    }
}
