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

struct Provider: TimelineProvider {
    private let useCase = WidgetUseCase()
    // 초기 화면
    func placeholder(
        in context: Context
    ) -> WMBEntry {
        WMBEntry(
            date: Date(),
            responses: useCase.responses
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
                responses: useCase.responses
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
        useCase.fetchUserDefaultValue()
        let entry = WMBEntry(
            date: nextRefresh,
            responses: useCase.responses
        )
        let timeline = Timeline(
            entries: [entry],
            policy: .after(nextRefresh)
        )
        completion(timeline)
    }
}
