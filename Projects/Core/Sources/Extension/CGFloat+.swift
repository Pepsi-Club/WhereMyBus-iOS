//
//  CGFloat+.swift
//  Core
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import UIKit

public extension CGFloat {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
}

public extension IntegerLiteralType {
    /// CGFloat으로 변환
    var f: CGFloat {
        return CGFloat(self)
    }
}

public extension FloatLiteralType {
    /// CGFloat으로 변환
    var f: CGFloat {
        return CGFloat(self)
    }
}
