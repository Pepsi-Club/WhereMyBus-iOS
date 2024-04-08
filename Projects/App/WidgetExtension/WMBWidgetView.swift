//
//  WMBWidgetView.swift
//  AppUITests
//
//  Created by gnksbm on 4/4/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import SwiftUI
import WidgetKit

import Domain

struct WMBWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            switch entry.responses.isEmpty {
            case true:
                emptyView
            case false:
                arrivalInfoView
            }
        }
        // 버전 이슈로 일단 주석처리하겠습니다 
        //.widgetBackground(Color.white)
    }
    
    var emptyView: some View {
        VStack(alignment: .center) {
            Text("즐겨찾기를 추가해 도착 정보를 확인하세요")
                .multilineTextAlignment(.center)
        }
    }
    
    var arrivalInfoView: some View {
        VStack(alignment: .leading) {
            ForEach(
                entry.responses.prefix(1),
                id: \.busStopId
            ) { busStopResponse in
                HStack {
                    VStack(alignment: .leading) {
                        Text(busStopResponse.busStopName)
                    }
                    Spacer()
//                    HStack {
//                        Text("XX:XX 업데이트")
//                        if #available(iOSApplicationExtension 17.0, *) {
//                            Button(intent: ConfigurationAppIntent()) {
//                                Image(systemName: "arrow.left")
//                            }
//                            Button(intent: ConfigurationAppIntent()) {
//                                Image(systemName: "arrow.right")
//                            }
//                        } else {
//                            EmptyView()
//                        }
//                    }
                }
                Spacer()
                ForEach(
                    busStopResponse.buses,
                    id: \.hashValue
                ) { bus in
                    HStack {
                        Text(bus.busName)
                            .lineLimit(1)
                        Spacer()
                        Text(bus.firstArrivalState.toString)
                            .lineLimit(1)
                    }
                }
            }
        }
    }
}
// 버젼 이슈로 일단 주석 처리 하겠습니다
//extension View {
//    func widgetBackground(_ backgroundView: some View) -> some View {
//        if #available(iOSApplicationExtension 17.0, *) {
//            return containerBackground(for: .widget) {
//                backgroundView
//            }
//        } else {
//            return background(backgroundView)
//        }
//    }
//}

struct WMBWidgetView_Preview: PreviewProvider {
    static var previews: some View {
        WMBWidgetView(
            entry: WMBEntry(
                date: .now,
                responses: []
            )
        )
        .previewContext(
            WidgetPreviewContext(family: .systemSmall)
        )
        WMBWidgetView(
            entry: WMBEntry(
                date: .now,
                responses: []
            )
        )
        .previewContext(
            WidgetPreviewContext(family: .systemMedium)
        )
    }
}
