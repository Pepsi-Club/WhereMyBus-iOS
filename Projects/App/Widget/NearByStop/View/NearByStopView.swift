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
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text("주변")
                    Text("정류장")
                }
                .font(.nanumHeavySU(size: 20))
                
                Spacer()
            }
            Spacer()
            
            Text(entry.busStopName)
                .font(.nanumRegularSU(size: 16))
            Text("\(entry.distance)m")
                .font(.nanumExtraBoldSU(size: 16))
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
