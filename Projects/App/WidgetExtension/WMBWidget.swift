//
//  WMBWidget.swift
//  WidgetExtension
//
//  Created by gnksbm on 4/4/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import WidgetKit
import SwiftUI

struct WMBWidget: Widget {
    let kind: String = "WidgetExtension"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            WMBWidgetView(
                entry: entry
            )
        }
    }
}

#if DEBUG
struct WidgetExtension_Preview: PreviewProvider {
    static var previews: some View {
        WMBWidgetView(
            entry: WMBEntry(
                date: .now,
                responses: .mock
            )
        )
        .previewContext(
            WidgetPreviewContext(family: .systemMedium)
        )
    }
}
#endif
