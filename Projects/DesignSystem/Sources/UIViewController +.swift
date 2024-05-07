//
//  UIViewController +.swift
//  DesignSystem
//
//  Created by 유하은 on 5/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

extension UIViewController {
    public func applyGlobalViewStyle() {
        view.layoutMargins = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0
        )
        
        view.backgroundColor = DesignSystemAsset.cellColor.color
    }
}
