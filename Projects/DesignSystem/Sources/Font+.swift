//
//  Font+.swift
//  DesignSystem
//
//  Created by Jisoo HAM on 4/17/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import SwiftUI

public extension Font {
    typealias Nanum = DesignSystemFontFamily.NanumSquareNeoOTF
    
    static func nanumLightSU(size: CGFloat) -> Font {
        Nanum.light.swiftUIFont(size: size)
    }
    
    static func nanumRegularSU(size: CGFloat) -> Font {
        Nanum.regular.swiftUIFont(size: size)
    }
    
    static func nanumBoldSU(size: CGFloat) -> Font {
        Nanum.bold.swiftUIFont(size: size)
    }
    
    static func nanumExtraBoldSU(size: CGFloat) -> Font {
        Nanum.extraBold.swiftUIFont(size: size)
    }
    
    static func nanumHeavySU(size: CGFloat) -> Font {
        Nanum.heavy.swiftUIFont(size: size)
    }
}
