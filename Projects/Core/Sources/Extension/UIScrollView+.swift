//
//  UIScrollView+.swift
//  Core
//
//  Created by Jisoo HAM on 3/11/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

public extension UIScrollView {
    func enableRefreshControl(
        refreshStr: String,
        refreshMsgColor: UIColor = DesignSystemAsset.mainColor.color,
        progressColor: UIColor = DesignSystemAsset.mainColor.color
    ) -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.endRefreshing()
        
        self.refreshControl = refreshControl
        
        refreshControl.tintColor = progressColor
        refreshControl.attributedTitle = NSAttributedString(
            string: "\(refreshStr)",
            attributes: [.foregroundColor: refreshMsgColor]
        )
        return refreshControl
    }
}
