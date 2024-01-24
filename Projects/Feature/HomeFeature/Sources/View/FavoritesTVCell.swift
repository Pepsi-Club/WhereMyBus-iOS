//
//  FavoritesTVCell.swift
//  HomeFeature
//
//  Created by gnksbm on 1/23/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core
import DesignSystem

class FavoritesTVCell: UITableViewCell {
    private let likeBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        let image = UIImage(systemName: "star")
        let imgConfig = UIImage.SymbolConfiguration(
            font: .systemFont(ofSize: 13)
        )
        config.image = image
        config.preferredSymbolConfigurationForImage = imgConfig
        config.baseForegroundColor = DesignSystemAsset.mainColor.color
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let routeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 18,
            weight: .bold
        )
        label.textColor = DesignSystemAsset.limeGreen.color
        return label
    }()
    
    private let firstArrivalInfoView = ArrivalInfoView()
    private let secondArrivalInfoView = ArrivalInfoView()
    
    private lazy var arrivalInfoStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [firstArrivalInfoView, secondArrivalInfoView]
        )
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    private let alarmBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        let image = UIImage(systemName: "deskclock")
        let imgConfig = UIImage.SymbolConfiguration(
            font: .systemFont(ofSize: 13)
        )
        config.image = image
        config.preferredSymbolConfigurationForImage = imgConfig
        config.baseForegroundColor = DesignSystemAsset.mainColor.color
        let button = UIButton(configuration: config)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        likeBtn.configuration?.image = UIImage(systemName: "star")
        alarmBtn.configuration?.image = UIImage(systemName: "deskclock")
        [routeLabel].forEach {
            $0.text = nil
        }
    }
    
    func updateUI(
        busRoute: String?,
        firstArrivalTime: String?,
        secondArrivalTime: String?,
        firstArrivalRemaining: String?,
        secondArrivalRemaining: String?
    ) {
        routeLabel.text = busRoute
        firstArrivalInfoView.updateUI(
            time: firstArrivalTime, remainingStops: firstArrivalRemaining
        )
        secondArrivalInfoView.updateUI(
            time: secondArrivalTime, remainingStops: secondArrivalRemaining
        )
    }
    
    private func configureUI() {
        contentView.backgroundColor = DesignSystemAsset.gray1.color
        
        [likeBtn, alarmBtn, routeLabel, arrivalInfoStackView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ).isActive = true
        }
        
        NSLayoutConstraint.activate([
            likeBtn.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 10
            ),
            
            routeLabel.trailingAnchor.constraint(
                equalTo: contentView.centerXAnchor,
                constant: -30
            ),
            
            arrivalInfoStackView.trailingAnchor.constraint(
                equalTo: contentView.centerXAnchor,
                constant: 10
            ),
            
            alarmBtn.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10
            ),
        ])
    }
}
