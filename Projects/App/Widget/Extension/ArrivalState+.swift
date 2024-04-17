//
//  ArrivalState+.swift
//  Widget
//
//  Created by 유하은 on 4/18/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import DesignSystem
import Domain

extension ArrivalState {
    public var toColor: DesignSystemColors.Color {
        switch self {
        case .soon:
                .red
        case .pending:
                .red
        case .finished:
                .red
        case .arrivalTime(time: let time):
                .red
        }
    }
}
