//
//  NearByStopView.swift
//  Widget
//
//  Created by gnksbm on 4/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import SwiftUI
import WidgetKit

struct NearByStopView: View {
    let entry: NearByStopProvider.Entry
    
    var body: some View {
        VStack {
            Text(entry.busStopName)
            Text("\(entry.distance)m")
        }
        .widgetBackground(Color.white)
    }
}

#if DEBUG
struct NearByStopView_Preview: PreviewProvider {
    static var previews: some View {
        NearByStopView(
            entry: .mock
        )
        .previewContext(
            WidgetPreviewContext(family: .systemSmall)
        )
    }
}
#endif
