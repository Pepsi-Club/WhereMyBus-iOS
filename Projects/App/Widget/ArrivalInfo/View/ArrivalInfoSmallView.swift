//
//  ArrivalInfoSmallView.swift
//  AppUITests
//
//  Created by gnksbm on 4/4/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import SwiftUI
import WidgetKit

import Core
import Domain

@available(iOS 17.0, *)
struct ArrivalInfoSmallView: View {
    var entry: ArrivalInfoProvider.Entry
    
    var url: URL? {
        var url: URL?
        if let busStopId = entry.responses.first?.busStopId {
            url = .init(string: "widget://deeplink?busStop=\(busStopId)")
        }
        return url
    }
    
    var body: some View {
        VStack {
            switch entry.responses.isEmpty {
            case true:
                emptyView
            case false:
                arrivalInfoView
            }
        }
        .widgetURL(url)
    }
    
    var emptyView: some View {
        VStack(alignment: .center) {
            Text("즐겨찾기를 추가해 도착 정보를 확인하세요")
                .font(.custom("", size: 20))
                .multilineTextAlignment(.center)
        }
    }
    
    var arrivalInfoView: some View {
        VStack(alignment: .leading) {
            ForEach(
                entry.responses.prefix(1),
                id: \.busStopId
            ) { busStopResponse in
                RefreshView(entry: entry)
                HStack {
                    VStack(alignment: .leading) {
                        Text(busStopResponse.busStopName)
                            .font(.headline)
                            .lineLimit(1)
                        Text(busStopResponse.direction)
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                }
                Spacer()
                ForEach(
                    busStopResponse.buses.prefix(2),
                    id: \.hashValue
                ) { bus in
                    HStack {
                        Text(bus.busName)
                            .font(.subheadline)
                        Spacer()
                        Text(bus.firstArrivalState.toString)
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                }
            }
        }
    }
}

#if DEBUG
@available(iOS 17.0, *)
struct ArrivalInfoSmallView_Preview: PreviewProvider {
    static var previews: some View {
        ArrivalInfoSmallView(
            entry: ArrivalInfoEntry(
                date: .now,
                configuration: .init()
            )
        )
        .widgetBackground()
        .previewContext(
            WidgetPreviewContext(family: .systemSmall)
        )
        ArrivalInfoSmallView(
            entry: ArrivalInfoEntry(
                date: .now,
                configuration: .init(),
                responses: .mock
            )
        )
        .widgetBackground()
        .previewContext(
            WidgetPreviewContext(family: .systemSmall)
        )
    }
}
#endif
