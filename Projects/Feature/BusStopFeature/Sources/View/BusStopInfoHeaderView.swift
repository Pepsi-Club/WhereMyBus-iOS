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
    
    private let textStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let btnStack: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .systemBlue
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var busStopNumLb: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .regular.font(size: 15)
        label.textColor = .white
        return label
    }()
    
    var busStopNameLb: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .heavy.font(size: 20)
        label.textColor = .white
        return label
    }()
    
    var nextStopNameLb: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .bold.font(size: 16)
        label.textColor = .white
        return label
    }()
    
    let favoriteBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "star")
        var title = AttributedString.init(stringLiteral: "즐겨찾기")
        title.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .regular.font(size: 15)
        config.attributedTitle = title
        
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .orange
        
        config.titlePadding = 10
        config.imagePadding = 10
        config.contentInsets = NSDirectionalEdgeInsets.init(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10
        )
        config.cornerStyle = .capsule
        
        let btn = UIButton(configuration: config)
        btn.tintColor = .orange
        return btn
    }()
    
    let mapBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        
        config.image = UIImage(systemName: "map")
        
        var title = AttributedString.init(stringLiteral: "지도")
        title.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .regular.font(size: 15)
        config.attributedTitle = title
        
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .orange
        
        config.titlePadding = 10
        config.imagePadding = 10
        config.contentInsets = NSDirectionalEdgeInsets.init(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10
        )
        config.cornerStyle = .capsule
        
        let btn = UIButton(configuration: config)
        btn.tintColor = .orange
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBlue
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
        addSubview(textStack)
        
        [busStopNumLb, busStopNameLb, nextStopNameLb, btnStack]
            .forEach { components in
                textStack.addArrangedSubview(components)
            }
        
        [favoriteBtn, mapBtn]
            .forEach { components in
                btnStack.addArrangedSubview(components)
            }
    }
    
    private func configureLayouts() {
        
        NSLayoutConstraint.activate([
            textStack.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            textStack.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            textStack.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 50
            ),
            textStack.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10
            )
        ])
    }
}
