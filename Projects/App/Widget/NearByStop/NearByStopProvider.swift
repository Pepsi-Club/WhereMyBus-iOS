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
        NearByStopEntry.mock
    }
    
    func getSnapshot(
        in context: Context,
        completion: @escaping (NearByStopEntry) -> Void
    ) {
        completion(NearByStopEntry.mock)
    }
    
    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<NearByStopEntry>) -> Void
    ) {
        let timeline = Timeline(
            entries: [NearByStopEntry.mock],
            policy: .never
        )
        completion(timeline)
    }
    
    typealias Entry = NearByStopEntry
}
