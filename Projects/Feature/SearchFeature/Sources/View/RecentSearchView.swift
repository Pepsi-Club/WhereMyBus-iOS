//
//  RecentSearchView.swift
//  SearchFeatureDemo
//
//  Created by 유하은 on 2024/02/04.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core
import DesignSystem

final class RecentSearchView: UITableViewHeaderFooterView {
    
    private let recentSearchLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 16)
        label.textColor = DesignSystemAsset.routeTimeColor.color
        return label
    }()
    
    private let busStopNameLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 14)
        label.textAlignment = .left
        label.textColor = .black
        
        return label
    }()
    
    private let numberDirectionLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 11)
        label.textAlignment = .left
        label.textColor = DesignSystemAsset.gray5.color
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [busStopNameLabel, numberDirectionLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            busStopNameLabel.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor,
                       constant: 30),
            numberDirectionLabel.leadingAnchor
                .constraint(equalTo: busStopNameLabel.leadingAnchor)
        ])
    }
}
