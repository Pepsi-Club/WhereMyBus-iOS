//
//  BusStopInfoHeaderView.swift
//  BusStopFeatureDemo
//
//  Created by Jisoo HAM on 2/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

final class BusStopInfoHeaderView: UIView {
    
    private let totalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 7
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let busIconStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = -2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let btnStack: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = DesignSystemAsset.headerBlue.color
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let busStopNumLb: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .regular.font(size: 15)
        label.textColor = .white
        return label
    }()
    
    private let busStopNameLb: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .heavy.font(size: 18)
        label.textColor = .white
        return label
    }()
    
    private let nextStopNameLb: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .bold.font(size: 12)
        label.textColor = .white
        return label
    }()
    
    let favoriteBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "star")
        var title = AttributedString.init(stringLiteral: "즐겨찾기")
        title.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .regular.font(size: 10)
        config.attributedTitle = title
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .orange
        config.imagePadding = 3
        let imgConfig = UIImage.SymbolConfiguration(
            font: .systemFont(ofSize: 11)
        )
        config.preferredSymbolConfigurationForImage = imgConfig
        config.cornerStyle = .capsule
        let btn = UIButton(configuration: config)
        return btn
    }()
    
    let mapBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        
        config.image = UIImage(systemName: "map")
        
        var title = AttributedString.init(stringLiteral: "지도")
        title.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .regular.font(size: 10)
        config.attributedTitle = title
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .orange
        config.imagePadding = 7
        let imgConfig = UIImage.SymbolConfiguration(
            font: .systemFont(ofSize: 11)
        )
        config.preferredSymbolConfigurationForImage = imgConfig
        config.cornerStyle = .capsule
        let btn = UIButton(configuration: config)
        return btn
    }()
    
    private let busStopIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DesignSystemAsset.busStop.image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = DesignSystemAsset.headerBlue.color
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bindUI(
        routeId: String,
        busStopName: String,
        nextStopName: String
    ) {
            busStopNumLb.text = routeId
            busStopNameLb.text = busStopName
            nextStopNameLb.text = nextStopName
    }
}

extension BusStopInfoHeaderView {
    private func configureUI() {
        configureSetup()
        configureLayouts()
    }
    
    private func configureSetup() {
        addSubview(totalStack)
        
        [busStopIcon, busStopNumLb]
            .forEach { components in
                busIconStack.addArrangedSubview(components)
            }
        
        [busIconStack, busStopNameLb, nextStopNameLb, btnStack]
            .forEach { components in
                totalStack.addArrangedSubview(components)
            }
        
        [favoriteBtn, mapBtn]
            .forEach { components in
                btnStack.addArrangedSubview(components)
            }
    }
    
    private func configureLayouts() {
        
        NSLayoutConstraint.activate([
            totalStack.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            totalStack.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            totalStack.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 30
            ),
            totalStack.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -15
            )
        ])
    }
}
