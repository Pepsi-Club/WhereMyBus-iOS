//
//  ArrivalInfoSmall2View.swift
//  AppUITests
//
//  Created by 유하은 on 4/16/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import SwiftUI
import WidgetKit

struct ArrivalInfoSmall2View: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#if DEBUG
@available(iOS 17.0, *)
struct ArrivalInfoSmall2View_preview: PreviewProvider {
    static var previews: some View {
        ArrivalInfoMediumView(
            entry: ArrivalInfoEntry(
                date: .now,
                configuration: .init()
            )
        )
        .widgetBackground()
        .previewContext(
            WidgetPreviewContext(family: .systemMedium)
        )
    }
}
#endif
