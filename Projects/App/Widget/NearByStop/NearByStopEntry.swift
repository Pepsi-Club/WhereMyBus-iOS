//
//  NearByStopEntry.swift
//  Widget
//
//  Created by gnksbm on 4/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import WidgetKit

struct NearByStopEntry: TimelineEntry {
    let date: Date
    let busStopName: String
    let distance: Int
}

#if DEBUG
extension NearByStopEntry {
    static let mock: Self = .init(
        date: .now,
        busStopName: "강남역 2호선",
        distance: 20
    )
}
#endif
