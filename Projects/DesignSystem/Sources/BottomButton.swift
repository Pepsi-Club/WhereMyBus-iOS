//
//  BottomButton.swift
//  DesignSystem
//
//  Created by gnksbm on 2/2/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public final class BottomButton: UIButton {
    public init(
        title: String
    ) {
        super.init(frame: .zero)
        var config = UIButton.Configuration.filled()
        var attributeContainer = AttributeContainer()
        let font = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
            size: 18
        )
        attributeContainer.font = font
        config.attributedTitle = .init(
            title,
            attributes: attributeContainer
        )
        config.cornerStyle = .capsule
        config.contentInsets = .init(
            top: 15,
            leading: 0,
            bottom: 15,
            trailing: 0
        )
        configuration = config
        tintColor = DesignSystemAsset.bottonBtnColor.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
