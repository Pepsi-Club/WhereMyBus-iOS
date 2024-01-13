//
//  ReusableView+.swift
//  Core
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import UIKit

public extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
