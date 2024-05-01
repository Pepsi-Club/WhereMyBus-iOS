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
        let imgView = LottieAnimationView(name: "list")
        imgView.contentMode = .scaleAspectFill
        imgView.loopMode = .loop
        imgView.animationSpeed = 0.5
        imgView.play()
        return imgView
    }()
    
    private let starImageView: LottieAnimationView = {
        let imgView = LottieAnimationView(name: "star")
        imgView.contentMode = .scaleAspectFit
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
                .foregroundColor: DesignSystemAsset.bottonBtnColor.color
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
    
    private let exampleRouteNumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.text = "777"
        label.textColor = DesignSystemAsset.gray4.color
        return label
    }()
    
    private let exampleArrivalInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        let remainingString = NSAttributedString(
            string: "곧 도착",
            attributes: [
                .font: UIFont.systemFont(ofSize: 20),
                .foregroundColor: DesignSystemAsset.lightRed.color
            ]
        )
        let timeString = NSAttributedString(
            string: "\n10분",
            attributes: [
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: DesignSystemAsset.gray5.color
            ]
        )
        let attrString = NSMutableAttributedString()
        attrString.append(remainingString)
        attrString.append(timeString)
        label.attributedText = attrString
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var exampleStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                exampleRouteNumLabel,
                exampleArrivalInfoLabel
            ]
        )
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.backgroundColor = DesignSystemAsset.gray2.color
        stackView.layer.cornerRadius = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .white
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
            
//            exampleStackView.centerXAnchor.constraint(
//                equalTo: centerXAnchor
//            ),
//            exampleStackView.widthAnchor.constraint(
//                equalTo: widthAnchor,
//                multiplier: 0.8
//            ),
//            exampleStackView.heightAnchor.constraint(
//                equalToConstant: 100
//            ),
//            exampleStackView.topAnchor.constraint(
//                equalTo: messageLabel.bottomAnchor,
//                constant: 30
//            ),
//            
//            exampleLabel.centerYAnchor.constraint(
//                equalTo: exampleStackView.topAnchor
//            ),
//            exampleLabel.centerXAnchor.constraint(
//                equalTo: exampleStackView.leadingAnchor
//            ),
        ])
//        exampleStackView.addDivider(
//            color: DesignSystemAsset.gray6.color,
//            hasPadding: true,
//            dividerRatio: 0.8
//        )
    }
}
