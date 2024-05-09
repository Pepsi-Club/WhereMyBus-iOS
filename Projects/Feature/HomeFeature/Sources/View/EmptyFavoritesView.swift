//
//  EmptyFavoritesView.swift
//  HomeFeature
//
//  Created by gnksbm on 2/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit
import Lottie
import DesignSystem

final class EmptyFavoritesView: UIView {
    private let listLottieView: LottieAnimationView = {
        let imgView = LottieAnimationView(
            name: "list",
            configuration: LottieConfiguration(renderingEngine: .mainThread)
        )
        imgView.contentMode = .scaleAspectFill
        imgView.loopMode = .loop
        imgView.animationSpeed = 0.5
        imgView.play()
        return imgView
    }()
    
    private let starImageView: LottieAnimationView = {
        let imgView = LottieAnimationView(
            name: "star",
            configuration: LottieConfiguration(renderingEngine: .mainThread)
        )
        imgView.contentMode = .scaleAspectFit
        imgView.loopMode = .loop
        imgView.animationSpeed = 0.5
        imgView.play()
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = DesignSystemAsset.cellColor.color
        [
            listLottieView,
            starImageView
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            listLottieView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            listLottieView.bottomAnchor.constraint(
                equalTo: centerYAnchor
            ),
            
            starImageView.leadingAnchor.constraint(
                equalTo: listLottieView.leadingAnchor,
                constant: -10
            ),
            starImageView.bottomAnchor.constraint(
                equalTo: listLottieView.topAnchor,
                constant: 80
            ),
            starImageView.widthAnchor.constraint(
                equalToConstant: 40
            ),
            starImageView.heightAnchor.constraint(
                equalToConstant: 40
            ),
        ])
//        exampleStackView.addDivider(
//            color: DesignSystemAsset.gray6.color,
//            hasPadding: true,
//            dividerRatio: 0.8
//        )
    }
}
