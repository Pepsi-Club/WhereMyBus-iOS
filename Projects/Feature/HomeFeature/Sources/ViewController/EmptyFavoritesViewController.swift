//
//  EmptyFavoritesViewController.swift
//  HomeFeature
//
//  Created by gnksbm on 1/26/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core
import DesignSystem

import RxCocoa

final class EmptyFavoritesViewController: UIViewController {
    private let viewModel: EmptyFavoritesViewModel
    
    private let searchBtn = SearchStationBtn(
        title: "버스 정류장을 검색하세요",
        image: UIImage(systemName: "magnifyingglass")
    )
    
    private let starImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = DesignSystemAsset.emptyFavoritesStars.image
        return imgView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 16,
            weight: .thin
        )
        label.text = "다음 버스 도착 시간까지 알고 싶다면\n즐겨찾기를 추가해보세요."
        label.numberOfLines = 2
        label.textColor = .black
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
        stackView.addDivider(
            color: DesignSystemAsset.gray6.color,
            hasPadding: true,
            dividerRatio: 0.8
        )
        stackView.backgroundColor = DesignSystemAsset.gray2.color
        stackView.layer.cornerRadius = 10
        return stackView
    }()
    
    init(viewModel: EmptyFavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        [
            searchBtn,
            starImgView,
            messageLabel,
            exampleStackView,
            exampleLabel,
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            searchBtn.topAnchor.constraint(equalTo: safeArea.topAnchor),
            searchBtn.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            searchBtn.widthAnchor.constraint(
                equalTo: safeArea.widthAnchor,
                multiplier: 0.95
            ),
            
            messageLabel.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
            messageLabel.bottomAnchor.constraint(
                equalTo: safeArea.centerYAnchor
            ),
            
            starImgView.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
            starImgView.bottomAnchor.constraint(
                equalTo: messageLabel.topAnchor,
                constant: -30
            ),
            
            exampleStackView.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
            exampleStackView.widthAnchor.constraint(
                equalTo: safeArea.widthAnchor,
                multiplier: 0.8
            ),
            exampleStackView.heightAnchor.constraint(
                equalToConstant: 100
            ),
            exampleStackView.topAnchor.constraint(
                equalTo: messageLabel.bottomAnchor,
                constant: 30
            ),
            
            exampleLabel.centerYAnchor.constraint(
                equalTo: exampleStackView.topAnchor
            ),
            exampleLabel.centerXAnchor.constraint(
                equalTo: exampleStackView.leadingAnchor
            ),
        ])
    }
    
    private func bind() {
        _ = viewModel.transform(
            input: .init(
                searchBtnTapEvent: searchBtn.rx.tap.asObservable()
            )
        )
    }
}
