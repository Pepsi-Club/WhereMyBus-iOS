//
//  MainTab.swift
//  MainFeature
//
//  Created by gnksbm on 2024/01/09.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

enum MainTab: Int, CaseIterable {
    case home, map, my
    
    var tabItem: UITabBarItem {
        switch self {
        case .home:
            return .init(
                title: "홈",
                image: .init(systemName: "house"),
                tag: rawValue
            )
        case .map:
            return .init(
                title: "지도",
                image: .init(systemName: "map"),
                tag: rawValue
            )
        case .my:
            return .init(
                title: "마이",
                image: .init(systemName: "person"),
                tag: rawValue
            )
        }
    }
}
