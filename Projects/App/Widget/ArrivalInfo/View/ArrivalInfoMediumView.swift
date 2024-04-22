//
//  ArrivalInfoMediumView.swift
//  Widget
//
//  Created by gnksbm on 4/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import SwiftUI
import WidgetKit

import Domain

@available(iOS 17.0, *)
struct ArrivalInfoMediumView: View {
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
                .multilineTextAlignment(.center)
        }
    }
    
    var arrivalInfoView: some View {
        VStack(alignment: .leading) {
            ForEach(
                entry.responses.prefix(1),
                id: \.busStopId
            ) { busStopResponse in
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(busStopResponse.busStopName)
                            .font(.headline)
                            .lineLimit(1)
                        Text(busStopResponse.direction)
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                    RefreshView(entry: entry)
                }
                Spacer()
                ForEach(
                    busStopResponse.buses.prefix(1),
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
struct ArrivalInfoMediumView_Preview: PreviewProvider {
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
        ArrivalInfoMediumView(
            entry: ArrivalInfoEntry(
                date: .now,
                configuration: .init(),
                responses: .mock
            )
        )
        .widgetBackground()
        .previewContext(
            WidgetPreviewContext(family: .systemMedium)
        )
    }
}
#endif
