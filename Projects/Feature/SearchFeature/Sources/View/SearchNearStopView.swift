//
//  SearchNearStopView.swift
//  SearchFeatureDemo
//
//  Created by 유하은 on 2024/02/05.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core
import DesignSystem

final class SearchNearStopView: UIButton {
    //    private let nearStopLabel: UILabel = {
    //        let label = UILabel()
    //        label.font = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 16)
    //
    //        return label
    //    }()
    
    private let busStopImage: UIImageView = {
        let originalImage = UIImage(named: "star")
        let resizedImage = originalImage?.withRenderingMode(.alwaysTemplate)
        let imageSize = CGSize(width: 20, height: 20)
        
        let imageView = UIImageView(image: resizedImage)
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    
    private let nearStopLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(size: 18)
        
        return label
    }()
    
    private let nearStopNameLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 15)
        label.textColor = DesignSystemAsset.gray6.color
        
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 15)
        label.textColor = DesignSystemAsset.lightRed.color
        
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
        busStopImage
            .translatesAutoresizingMaskIntoConstraints = false
        nearStopLabel
            .translatesAutoresizingMaskIntoConstraints = false
        nearStopNameLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel
            .translatesAutoresizingMaskIntoConstraints = false

        addSubview(nearStopLabel)
        addSubview(nearStopNameLabel)
        addSubview(distanceLabel)
        addSubview(busStopImage)

        NSLayoutConstraint.activate([
            busStopImage.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                  constant: 40),
            
            nearStopNameLabel.leadingAnchor.constraint(
                equalTo: busStopImage.trailingAnchor, constant: 30),
            nearStopNameLabel.topAnchor.constraint(
                equalTo: distanceLabel.bottomAnchor, constant: 10),
            
            distanceLabel.topAnchor.constraint(
                equalTo: distanceLabel.bottomAnchor, constant: 10),
            distanceLabel.leadingAnchor.constraint(
                equalTo: trailingAnchor, constant: 20),
        ])
    }
}
