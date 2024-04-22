//
//  ReloadWidgetIntent.swift
//  Widget
//
//  Created by 유하은 on 4/22/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import AppIntents
import WidgetKit

struct ReloadWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "Reload widget"
    static var description = IntentDescription("Reload widget.")

    init() {}

    func perform() async throws -> some IntentResult {
        return .result()
        WidgetCenter.shared.reloadTimelines(ofKind: "")
    }
}
