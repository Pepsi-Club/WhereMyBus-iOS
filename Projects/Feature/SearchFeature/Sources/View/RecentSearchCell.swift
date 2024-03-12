//
//  RecentSearchCell.swift
//  SearchFeature
//
//  Created by 유하은 on 2024/02/27.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core
import DesignSystem

import RxSwift

final class RecentSearchCell: UITableViewCell {
    public var disposeBag = DisposeBag()
    
    public let searchBtnTapEvent = PublishSubject<String>()
    
    public var busStopNameLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 16)
        label.textAlignment = .left
        label.textColor = .black
        
        return label
    }()
    
    public var numberLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 13)
        label.textAlignment = .left
        label.textColor = DesignSystemAsset.gray5.color
        
        return label
    }()
    
    private let line: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 13)
        label.textAlignment = .left
        label.textColor = DesignSystemAsset.gray5.color
        label.text = "|"
        
        return label
    }()
    
    public var dircetionLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 13)
        label.textAlignment = .left
        label.textColor = DesignSystemAsset.gray5.color
        
        return label
    }()
    
    private let numDirectStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 3
        return stack
    }()
    
    private let totalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
        stack.spacing = 3
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        [busStopNameLabel, numberLabel, line, dircetionLabel, numDirectStack,
         totalStack].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [numberLabel, line, dircetionLabel]
            .forEach { components in
                numDirectStack.addArrangedSubview(components)
            }
        
        [busStopNameLabel, numDirectStack]
            .forEach { components in
                totalStack.addArrangedSubview(components)
            }
        
        NSLayoutConstraint.activate([
            busStopNameLabel.leadingAnchor
                .constraint(equalTo: leadingAnchor,
                            constant: 30),
            busStopNameLabel.topAnchor
                .constraint(equalTo: bottomAnchor,
                            constant: 50),
            
            numDirectStack.leadingAnchor
                .constraint(equalTo: busStopNameLabel.leadingAnchor),
            numDirectStack.topAnchor
                .constraint(equalTo: busStopNameLabel.bottomAnchor,
                            constant: 5)
            
        ])
    }
}
