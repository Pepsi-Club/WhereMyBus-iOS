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
        .widgetBackground(Color.white)
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
                VStack(alignment: .leading) {
                    Text(busStopResponse.busStopName)
                        .font(.subheadline)
                        .lineLimit(2)
                }
                ForEach(
                    busStopResponse.buses.prefix(1),
                    id: \.hashValue
                ) { bus in
                    VStack(alignment: .leading) {
                        Text(bus.busName)
                            .font(.subheadline)
                        Text(bus.firstArrivalState.toString)
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                    .padding(1)
                }
            }
        }
    }
}

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}

#if DEBUG
struct WMBWidgetView_Preview: PreviewProvider {
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
