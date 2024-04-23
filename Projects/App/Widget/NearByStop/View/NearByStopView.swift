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
            HStack {
                VStack(alignment: .leading) {
                    Text("주변")
                        .padding(EdgeInsets(
                            top: 0,
                            leading: 0,
                            bottom: -2,
                            trailing: 0
                        ))
                    Text("정류장")
                }
                .foregroundStyle(.white)
                .font(.nanumHeavySU(size: 21))
                
                Spacer()
            }
            .padding(EdgeInsets(
                top: 10,
                leading: 0,
                bottom: 15,
                trailing: 0
            ))
            
            Text(entry.busStopName)
                .foregroundStyle(.white)
                .font(.nanumBoldSU(size: 16))
                .padding(EdgeInsets(
                    top: 0,
                    leading: 0,
                    bottom: -3,
                    trailing: 0
                ))
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
//        .widgetURL(<#T##url: URL?##URL?#>)
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
