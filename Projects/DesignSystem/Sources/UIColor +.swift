//
//  UIColor +.swift
//  DesignSystem
//
//  Created by 유하은 on 5/7/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public extension UIColor {
    static var adaptiveWhiteforDesign: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(
                    red: 20/255,
                    green: 20/255,
                    blue: 23/255,
                    alpha: 1.0
                )
            } else {
                return UIColor.white
            }
        }
    }
    
    static var adaptiveBlackforDesign: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.white
            } else {
                return UIColor.black
            }
        }
    }
}
