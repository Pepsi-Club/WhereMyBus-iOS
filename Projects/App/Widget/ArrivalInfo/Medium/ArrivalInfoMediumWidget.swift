//
//  ArrivalInfoMediumWidget.swift
//  Widget
//
//  Created by gnksbm on 4/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import WidgetKit
import SwiftUI

@available(iOS 17.0, *)
struct ArrivalInfoMediumWidget: Widget {
    let kind: String = "ArrivalInfoMedium"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ArrivalInfoIntent.self,
            provider: ArrivalInfoProvider()
        ) { entry in
            ArrivalInfoMediumView(
                entry: entry
            )
        }
        .supportedFamilies([.systemMedium])
    }
}
