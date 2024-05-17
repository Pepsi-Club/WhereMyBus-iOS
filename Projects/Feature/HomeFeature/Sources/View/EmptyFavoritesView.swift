//
//  EmptyFavoritesView.swift
//  HomeFeature
//
//  Created by gnksbm on 2/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

import Lottie

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
    
    private let messageLabel: UILabel = {
            let label = UILabel()
            label.font = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
                size: 15
            )
            label.textColor = DesignSystemAsset.gray6.color
            label.textAlignment = .center
            label.numberOfLines = 3
            let message1 = NSAttributedString(
                string: "확인하고 싶은 버스 정보는\n",
                attributes: [
                .font: DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
                        size: 15
                    )
                ]
            )
            let message2 = NSAttributedString(
                string: "즐겨찾기로 등록하세요 ",
                attributes: [
                    .font: DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(
                        size: 20
                    ),
                    .foregroundColor: DesignSystemAsset.settingColor.color
                ]
            )
            let padding = NSAttributedString(
                string: "\n",
                attributes: [
                    .font: DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(
                        size: 6
                    ),
                    .foregroundColor: DesignSystemAsset.bottonBtnColor.color
                ]
            )
            let attributedString = NSMutableAttributedString()
            attributedString.append(message1)
            attributedString.append(padding)
            attributedString.append(message2)
            label.attributedText = attributedString
            return label
        }()

        private let exampleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(
                ofSize: 20,
                weight: .light
            )
            label.text = "ex"
            label.textColor = DesignSystemAsset.blueGray.color
            label.transform = CGAffineTransform(rotationAngle: -0.3)
            return label
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
            messageLabel,
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
            messageLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            messageLabel.bottomAnchor.constraint(
                equalTo: listLottieView.bottomAnchor,
                constant: 80
            ),
        ])
    }
}
