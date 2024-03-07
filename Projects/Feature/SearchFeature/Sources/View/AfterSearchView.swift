//
//  AfterSearchView.swift
//  SearchFeatureDemo
//
//  Created by 유하은 on 2024/02/04.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core
import DesignSystem

final class AfterSearchView: UIScrollView {
    
    private let busStopNameLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 16)
        label.textAlignment = .left
        label.textColor = .black

        return label
    }()

    private let numberDirectionLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 13)
        label.textAlignment = .left
        label.textColor = DesignSystemAsset.gray5.color

        return label
    }()
}
