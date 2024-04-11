//
//  Provider.swift
//  AppUITests
//
//  Created by gnksbm on 4/4/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import SwiftUI
import WidgetKit

import Core
import Domain

import RxSwift

struct Provider: TimelineProvider {
    // 초기 화면
    func placeholder(
        in context: Context
    ) -> WMBEntry {
        WMBEntry(
            date: Date(),
            responses: []
        )
    }
    // 미리보기 화면
    func getSnapshot(
        in context: Context,
        completion: @escaping (WMBEntry) -> Void
    ) {
        completion(
            WMBEntry(
                date: Date(),
                responses: []
            )
        )
    }
    
    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<WMBEntry>) -> Void
    ) {
        let nextRefresh = Calendar.current.date(
            byAdding: .hour,
            value: 1,
            to: Date()
        )!
        guard let datas = UserDefaults.appGroup?.array(
            forKey: "arrivalResponse"
        ) as? [Data]
        else {
            completion(
                Timeline(
                    entries: [
                        WMBEntry(
                            date: nextRefresh,
                            responses: []
                        )
                    ],
                    policy: .after(nextRefresh)
                )
            )
            return
        }
        let responses = datas.compactMap {
            return try? $0.decode(type: BusStopArrivalInfoResponse.self)
        }
        completion(
            Timeline(
                entries: [
                    WMBEntry(
                        date: nextRefresh,
                        responses: responses
                    )
                ],
                policy: .after(nextRefresh)
            )
        )
    }
}
