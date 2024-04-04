//
//  UIFont+.swift
//  DesignSystem
//
//  Created by gnksbm on 4/4/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public extension UIFont {
    typealias Nanum = DesignSystemFontFamily.NanumSquareNeoOTF
    
    static func nanumLight(size: CGFloat) -> UIFont {
        Nanum.light.font(size: size)
    }
    
    static func nanumRegular(size: CGFloat) -> UIFont {
        Nanum.regular.font(size: size)
    }
    
    static func nanumBold(size: CGFloat) -> UIFont {
        Nanum.bold.font(size: size)
    }
    
    static func nanumExtraBold(size: CGFloat) -> UIFont {
        Nanum.extraBold.font(size: size)
    }
    
    static func nanumHeavy(size: CGFloat) -> UIFont {
        Nanum.heavy.font(size: size)
    }
}
