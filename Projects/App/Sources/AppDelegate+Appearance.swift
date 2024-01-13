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
        let backgroundColor = DesignSystemAsset.backgroundColor.color
        let accentColor = DesignSystemAsset.accentColor.color
        UINavigationBar.appearance().backgroundColor = backgroundColor
        UITabBar.appearance().tintColor = accentColor
        UITabBar.appearance().isTranslucent = true
    }
}
