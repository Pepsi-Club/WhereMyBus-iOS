//
//  SettingView.swift
//  DesignSystem
//
//  Created by Jisoo HAM on 2/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public final class SettingView: UIView {
    
    private let title: String
    private let rightTitle: String?
    private let isHiddenArrowRight: Bool
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font 
        = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 18)
        label.textColor = DesignSystemAsset.mainColor.color
        label.text = title
        return label
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font 
        = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 15)
        label.textColor = DesignSystemAsset.mainColor.color
        label.text = rightTitle
        return label
    }()

    private lazy var arrowRightLabel: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "chevron.right"))
        view.contentMode = .scaleAspectFit
        view.tintColor = DesignSystemAsset.routeTimeColor.color
        return view
    }()
    
    private let separateBar: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystemAsset.remainingColor.color
        return view
    }()
    
    private let totalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 10
        return stack
    }()
    
    public init(title: String, rightTitle: String?, isHiddenArrowRight: Bool) {
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
        [titleLabel, rightLabel, arrowRightLabel, separateBar, totalStack]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        [totalStack, separateBar]
            .forEach {
                addSubview($0)
            }
        totalStack.addArrangedSubview(titleLabel)
        
        if isHiddenArrowRight {
            totalStack.addArrangedSubview(rightLabel)
            
        } else {
            totalStack.addArrangedSubview(arrowRightLabel)
            
        }
        
        NSLayoutConstraint.activate([
            totalStack.topAnchor.constraint(
                equalTo: topAnchor
            ),
            totalStack.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            totalStack.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            separateBar.topAnchor.constraint(
                equalTo: totalStack.bottomAnchor,
                constant: 10
            ),
            separateBar.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            separateBar.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            separateBar.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            separateBar.heightAnchor.constraint(
                equalToConstant: 1
            ),
        ])
    }
}
