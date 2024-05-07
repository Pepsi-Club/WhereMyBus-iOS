//
//  Appearance.swift
//  DesignSystem
//
//  Created by gnksbm on 1/26/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public final class Appearance {
    public static func setupAppearance() {
        _ = DesignSystemAsset.backgroundColor.color
        UINavigationBar.appearance().backgroundColor =
            DesignSystemAsset.cellColor.color
        UINavigationBar.appearance().tintColor =
        DesignSystemAsset.settingColor.color
        // 모든 BackButton의 타이틀을 없애버림
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(
            UIOffset(horizontal: -1000, vertical: 0),
            for: .default
        )
    }
    
    public static func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        let tintColor = DesignSystemAsset.settingColor.color
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = DesignSystemAsset.cellColor.color
        appearance.inlineLayoutAppearance = .init(style: .compactInline)
        UITabBar.appearance().tintColor = tintColor
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
