//
//  NearByStopProvider.swift
//  Widget
//
//  Created by gnksbm on 4/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import WidgetKit

struct NearByStopProvider: TimelineProvider {
    func placeholder(
        in context: Context
    ) -> NearByStopEntry {
        NearByStopEntry(
            date: .now,
            busStopName: "강남역 2호선",
            distance: 60
        )
    }
    
    func getSnapshot(
        in context: Context,
        completion: @escaping (NearByStopEntry) -> Void
    ) {
        completion(
            NearByStopEntry(
                date: .now,
                busStopName: "강남역 2호선",
                distance: 60
            )
        )
    }
    
    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<NearByStopEntry>) -> Void
    ) {
        let timeline = Timeline(
            entries: [
                NearByStopEntry(
                    date: .now,
                    busStopName: "강남역 2호선",
                    distance: 60
                )
            ],
            policy: .never
        )
        completion(timeline)
    }
    
    typealias Entry = NearByStopEntry
}
