//
//  RefreshView.swift
//  WidgetKit
//
//  Created by gnksbm on 4/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import SwiftUI

import Core

@available(iOS 17.0, *)
struct RefreshView: View {
    var entry: ArrivalInfoProvider.Entry
    
    var body: some View {
        HStack {
            Spacer()
            Text(entry.date.toString(dateFormat: "HH:mm 업데이트"))
                .font(.caption)
            Button(intent: entry.configuration) {
                Image(systemName: "arrow.clockwise")
            }
            .buttonStyle(.plain)
        }
    }
}
