//
//  SettingView.swift
//  DesignSystem
//
//  Created by Jisoo HAM on 2/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

final class SettingView: UIView {
    
    private let title: String
    private let rightTitle: String?
    private let isHiddenArrowRight: Bool
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font 
        = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 15)
        label.textColor = DesignSystemAsset.mainColor.color
        label.text = title
        return label
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font 
        = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 12)
        label.textColor = DesignSystemAsset.remainingColor.color
        label.text = rightTitle
        return label
    }()

    private lazy var arrowRightButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.right")
        let btn = UIButton(configuration: config)
        btn.isHidden = isHiddenArrowRight
        return btn
    }()
    
    private lazy var totalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    init(title: String, rightTitle: String?, isHiddenArrowRight: Bool) {
        self.title = title
        self.rightTitle = rightTitle
        self.isHiddenArrowRight = isHiddenArrowRight
        
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [titleLabel, rightLabel, arrowRightButton, totalStack]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        [titleLabel, rightLabel, arrowRightButton]
            .forEach { totalStack.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            totalStack.topAnchor.constraint(equalTo: topAnchor),
            totalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
