//
//  NearByStopView.swift
//  Widget
//
//  Created by gnksbm on 4/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import SwiftUI
import WidgetKit

import DesignSystem

struct NearByStopView: View {
    let entry: NearByStopProvider.Entry
    
    let backgroundColor = DesignSystemAsset.appColor.swiftUIColor
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text("주변")
                    Text("정류장")
                }
                .foregroundStyle(.white)
                .font(.nanumHeavySU(size: 20))
                
                Spacer()
            }
            Spacer()
            
            Text(entry.busStopName)
                .foregroundStyle(.white)
                .font(.nanumBoldSU(size: 16))
            Text("\(entry.distance)m")
                .foregroundStyle(
                    DesignSystemAsset.blueBus.swiftUIColor
                )
                .font(.nanumExtraBoldSU(size: 16))
                .padding(EdgeInsets(
                    top: 0.5,
                    leading: 0,
                    bottom: 0,
                    trailing: 0
                ))
        }
        .widgetBackground(backgroundColor)
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
