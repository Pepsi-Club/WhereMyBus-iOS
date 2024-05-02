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

import Lottie

final class SearchNearStopInformationView: UIButton {
    public let busStopImage: LottieAnimationView = {
        let imgView = LottieAnimationView(name: "cleanMap")
        imgView.contentMode = .scaleAspectFill
        imgView.loopMode = .loop
        imgView.backgroundBehavior = .pause
        imgView.animationSpeed = 0.5
        imgView.play()
        
        return imgView
    }()
    
    public let chevronIcon: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "chevron.right"))
        view.tintColor = DesignSystemAsset.gray4.color
        return view
    }()
    
    private let nearStopLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(size: 10)
        label.textColor = .black.withAlphaComponent(0.6)
        label.text = "근처 정류장"
        return label
    }()
    
    private let nearStopNameLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(size: 14)
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        label.minimumScaleFactor = 0.7
        label.sizeToFit()
        label.textColor = .black.withAlphaComponent(0.6)
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumBold(size: 11)
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
        backgroundColor = .white
        let symbolSize = 64
        
        [
            busStopImage,
            chevronIcon,
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
                constant: 0
            ),
            busStopImage.heightAnchor.constraint(
                equalToConstant: CGFloat(symbolSize)
            ),
            busStopImage.widthAnchor.constraint(
                equalToConstant: CGFloat(symbolSize)
            ),
            
            nearStopLabel.leadingAnchor.constraint(
                equalTo: busStopImage.trailingAnchor,
                constant: 0
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
            nearStopNameLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -20
            ),
            distanceLabel.leadingAnchor.constraint(
                equalTo: nearStopNameLabel.trailingAnchor,
                constant: 4
            ),
            distanceLabel.bottomAnchor.constraint(
                equalTo: nearStopNameLabel.bottomAnchor
            ),
            chevronIcon.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20
            ),
            chevronIcon.heightAnchor.constraint(
                equalToConstant: 20
            ),
            chevronIcon.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
        ])
    }
}
