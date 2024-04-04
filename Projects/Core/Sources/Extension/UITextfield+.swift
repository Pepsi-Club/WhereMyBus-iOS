//
//  UITextfield+.swift
//  Core
//
//  Created by gnksbm on 4/4/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public extension UITextField {
    func addLeftPadding(width: CGFloat) {
        let paddingView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: width,
                height: self.frame.height
            )
        )
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
