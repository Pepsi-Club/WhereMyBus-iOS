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
        let accentColor = DesignSystemAsset.accentColor.color
        let mainColor = DesignSystemAsset.mainColor.color
        let backgroundColor = DesignSystemAsset.backgroundColor.color
        let tabBackgroundColor = DesignSystemAsset.tabBackgroundColor.color
        UINavigationBar.appearance().backgroundColor = backgroundColor
        UINavigationBar.appearance().tintColor = .black
        UITabBar.appearance().backgroundColor = tabBackgroundColor
        UITabBar.appearance().tintColor = accentColor
        UITabBar.appearance().unselectedItemTintColor = mainColor
        UITabBar.appearance().isTranslucent = false
    }
}
