//
//  SearchNearStopInformationView.swift
//  SearchFeature
//
//  Created by 유하은 on 2024/03/07.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core
import DesignSystem

final class SearchNearStopInformationView: UIButton {
    
    private let busStopImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DesignSystemAsset.busStopImage1.image
        return imageView
    }()
    
    private let nearStopLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(size: 14)
        label.textColor = DesignSystemAsset.settingColor.color
        label.text = "내 주변 가장 가까운 정류장은?"
        return label
    }()
    
    private let nearStopNameLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 15)
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        label.minimumScaleFactor = 0.7
        label.sizeToFit()
        label.textColor = DesignSystemAsset.gray5.color
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumBold(size: 15)
        label.textColor = DesignSystemAsset.lightRed.color
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        drawShadow()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(
        busStopName: String,
        distance: String
    ) {
        nearStopNameLabel.text = busStopName
        distanceLabel.text = distance
    }
    
    private func drawShadow() {
        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 2
    }
    
    private func configureUI() {
        backgroundColor = DesignSystemAsset.gray2.color
        let symbolSize = 45
        
        [
            busStopImage,
            nearStopLabel,
            nearStopNameLabel,
            distanceLabel,
        ]
            .forEach { components in
                addSubview(components)
                components.translatesAutoresizingMaskIntoConstraints = false
            }
        
        NSLayoutConstraint.activate([
            
            busStopImage.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
            busStopImage.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 20
            ),
            busStopImage.heightAnchor.constraint(
                equalToConstant: CGFloat(symbolSize)
            ),
            busStopImage.widthAnchor.constraint(
                equalToConstant: CGFloat(symbolSize)
            ),
            
            nearStopLabel.leadingAnchor.constraint(
                equalTo: busStopImage.trailingAnchor,
                constant: 20
            ),
            nearStopLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 20
            ),
            nearStopNameLabel.topAnchor.constraint(
                equalTo: nearStopLabel.bottomAnchor,
                constant: 6
            ),
            nearStopNameLabel.leadingAnchor.constraint(
                equalTo: nearStopLabel.leadingAnchor
            ),
            nearStopNameLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -15
            ),
            nearStopNameLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -20
            ),
            
            distanceLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20
            ),
            distanceLabel.bottomAnchor.constraint(
                equalTo: nearStopNameLabel.bottomAnchor
            ),
        ])
    }
}
