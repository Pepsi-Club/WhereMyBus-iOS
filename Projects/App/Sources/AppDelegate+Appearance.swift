//
//  AppDelegate+Appearance.swift
//  YamYamPick
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import UIKit

import DesignSystem

extension AppDelegate {
    func setupAppearance() {
        let accentColor = DesignSystemAsset.accentColor.color
        let mainColor = DesignSystemAsset.mainColor.color
        let backgroundColor = DesignSystemAsset.backgroundColor.color
        let tabBackgroundColor = DesignSystemAsset.tabBackgroundColor.color
        UINavigationBar.appearance().backgroundColor = backgroundColor
        UITabBar.appearance().backgroundColor = tabBackgroundColor
        UITabBar.appearance().tintColor = accentColor
        UITabBar.appearance().unselectedItemTintColor = mainColor
        UITabBar.appearance().isTranslucent = false
    }
}
