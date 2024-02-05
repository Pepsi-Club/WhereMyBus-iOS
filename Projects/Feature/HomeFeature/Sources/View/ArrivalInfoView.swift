//
//  ArrivalInfoView.swift
//  HomeFeature
//
//  Created by gnksbm on 1/24/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

final class ArrivalInfoView: UIStackView {
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
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addArrangedSubview(timeLabel)
        axis = .vertical
        alignment = .leading
        spacing = 6
    }
    
    func updateUI(
        time: String,
        remainingStops: String
    ) {
        let routeTimeColor = DesignSystemAsset.routeTimeColor.color
        let carrotOrange = DesignSystemAsset.carrotOrange.color
        if time.contains(where: { Int(String($0)) != nil }) {
            timeLabel.text = time + "분"
            timeLabel.textColor = routeTimeColor
        } else {
            timeLabel.text = time
            timeLabel.textColor = carrotOrange
        }
        
        if remainingStops.isEmpty {
            removeArrangedSubview(remainingLabel)
        } else {
            addArrangedSubview(remainingLabel)
            remainingLabel.text = remainingStops
        }
    }
}
