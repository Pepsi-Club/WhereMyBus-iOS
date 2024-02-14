//
//  SettingView.swift
//  DesignSystem
//
//  Created by Jisoo HAM on 2/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public final class SettingView: UIView {
    
    private let iconName: String
    private let title: String
    private let rightTitle: String?
    private let isHiddenArrowRight: Bool
    
    // public으로 event를 가지고 있어도 좋겠다 ! -> View에서 불러서 맵핑시키면
    // 여러 버튼으로 늘어났을때 이벤트 적용하면 더 좋겠다 !!
    
    private lazy var leftIconLabel: UIImageView = {
        let title = iconName
        let view = UIImageView(image: UIImage(systemName: title))
        view.tintColor = DesignSystemAsset.routeTimeColor.color
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font 
        = DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(size: 15)
        label.textColor = DesignSystemAsset.settingColor.color
        label.text = title
        return label
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font 
        = DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(size: 13)
        label.textColor = DesignSystemAsset.settingColor.color
        label.text = rightTitle
        return label
    }()

    private let arrowRightLabel: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "chevron.right"))
        view.tintColor = DesignSystemAsset.routeTimeColor.color
        return view
    }()
    
    public init(
        iconName: String,
        title: String,
        rightTitle: String?,
        isHiddenArrowRight: Bool
    ) {
        self.iconName = iconName
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
        [titleLabel, rightLabel, arrowRightLabel, leftIconLabel]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        [leftIconLabel, titleLabel]
            .forEach { addSubview($0) }
        
        if isHiddenArrowRight {
            addSubview(rightLabel)
            rightLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 2
            ).isActive = true
            rightLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ).isActive = true
            
        } else {
            addSubview(arrowRightLabel)
            arrowRightLabel.topAnchor.constraint(
                equalTo: topAnchor
            ).isActive = true
            arrowRightLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ).isActive = true
        }
        
        NSLayoutConstraint.activate([
            leftIconLabel.topAnchor.constraint(
                equalTo: topAnchor
            ),
            leftIconLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 2
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: leftIconLabel.trailingAnchor,
                constant: 15
            ),
        ])
    }
}
