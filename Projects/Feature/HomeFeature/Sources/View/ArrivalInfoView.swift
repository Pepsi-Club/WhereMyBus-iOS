//
//  ArrivalInfoView.swift
//  HomeFeature
//
//  Created by gnksbm on 1/24/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

final class ArrivalInfoView: UIView {
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(
            size: 14
        )
        label.textColor = DesignSystemAsset.routeTimeColor.color
        return label
    }()
    
    private let remainingLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF.light.font(
            size: 12
        )
        label.textColor = DesignSystemAsset.remainingColor.color
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [timeLabel, remainingLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            timeLabel.bottomAnchor.constraint(
                equalTo: centerYAnchor,
                constant: -3
            ),
            
            remainingLabel.topAnchor.constraint(
                equalTo: centerYAnchor,
                constant: 3
            )
        ])
    }
    
    func updateUI(
        time: String,
        remainingStops: String
    ) {
        var isContainTime = false
        if time.contains(where: { Int(String($0)) != nil }) {
            isContainTime = true
        }
        let routeTimeColor = DesignSystemAsset.routeTimeColor.color
        let carrotOrange = DesignSystemAsset.carrotOrange.color
        timeLabel.text = time
        timeLabel.textColor = isContainTime ?
        routeTimeColor : carrotOrange
        remainingLabel.text = remainingStops
    }
}
