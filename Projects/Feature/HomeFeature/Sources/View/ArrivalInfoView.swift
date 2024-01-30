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
        label.font = .systemFont(
            ofSize: 10,
            weight: .bold
        )
        label.textColor = .black
        return label
    }()
    
    private let remainingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 8,
            weight: .light
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
            $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            remainingLabel.leadingAnchor.constraint(
                equalTo: timeLabel.trailingAnchor,
                constant: 10
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
        let carrotOrange = DesignSystemAsset.carrotOrange.color
        timeLabel.text = time
        timeLabel.textColor = isContainTime ? .black : carrotOrange
        remainingLabel.text = remainingStops
    }
}
