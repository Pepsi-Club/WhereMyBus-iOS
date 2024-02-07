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

//TODO: TableView로 변경해야함

final class RecentSearchView: UIView {
    
    private let busStopNameLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 16)
        label.textAlignment = .left
        label.textColor = .black
        label.text = "강남CC"
        
        return label
    }()
    
    private let numberDirectionLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 13)
        label.textAlignment = .left
        label.textColor = DesignSystemAsset.gray5.color
        label.text = "1234 | 어쩌구방면"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [busStopNameLabel, numberDirectionLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            busStopNameLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor,
                       constant: 30),
            busStopNameLabel.topAnchor
                .constraint(equalTo: bottomAnchor,
                       constant: 50),
            
            numberDirectionLabel.leadingAnchor
                .constraint(equalTo: busStopNameLabel.leadingAnchor),
            numberDirectionLabel.topAnchor
            .constraint(equalTo: busStopNameLabel.bottomAnchor,
                       constant: 5)
            
        ])
    }
}
