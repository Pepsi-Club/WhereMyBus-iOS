//
//  BusTableViewCell.swift
//  BusStopFeatureDemo
//
//  Created by Jisoo HAM on 2/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

import RxSwift

final class BusTableViewCell: UITableViewCell {
    private var disposeBag = DisposeBag()

    private let firstArrivalInfoView = ArrivalInfoView()
    private let secondArrivalInfoView = ArrivalInfoView()
    
    let starBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "star")
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 15,
            bottom: 10,
            trailing: 5
        )
        let imgConfig = UIImage.SymbolConfiguration(
            font: .systemFont(ofSize: 13)
        )
        config.preferredSymbolConfigurationForImage = imgConfig
        config.baseForegroundColor = DesignSystemAsset.mainColor.color
        config.baseBackgroundColor = .clear
        let btn = UIButton(configuration: config)
        return btn
    }()
    
    let alarmBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "alarm")
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 5,
            bottom: 10,
            trailing: 15
        )
        let imgConfig = UIImage.SymbolConfiguration(
            font: .systemFont(ofSize: 13)
        )
        config.preferredSymbolConfigurationForImage = imgConfig
        config.baseForegroundColor = DesignSystemAsset.mainColor.color
        config.baseBackgroundColor = .clear
        let btn = UIButton(configuration: config)
        return btn
    }()
    
    private let totalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    private let busNumStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
        stack.spacing = 3
        return stack
    }()
    
    private let busNumber: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .bold.font(size: 18)
        label.textColor = DesignSystemAsset.blueBus.color
        return label
    }()
    
    private let nextStopName: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .regular.font(size: 14)
        label.textColor = DesignSystemAsset.remainingColor.color
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateUI(
        routeName: String,
        nextRouteName: String,
        firstArrivalTime: String,
        firstArrivalRemaining: String,
        secondArrivalTime: String,
        secondArrivalRemaining: String
    ) {
        busNumber.text = routeName
        nextStopName.text = nextRouteName
        firstArrivalInfoView.updateUI(
            time: firstArrivalTime, remainingStops: firstArrivalRemaining
        )
        secondArrivalInfoView.updateUI(
            time: secondArrivalTime, remainingStops: secondArrivalRemaining
        )
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension BusTableViewCell {
    private func configureUI() {
        contentView.addSubview(totalStack)
        
        [
            starBtn, alarmBtn, busNumStack,
            totalStack, busNumber, nextStopName,
            firstArrivalInfoView, secondArrivalInfoView
        ].forEach { components in
            components.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            busNumber, nextStopName
        ].forEach { components in
            busNumStack.addArrangedSubview(components)
        }
        
        [
            starBtn, busNumStack, firstArrivalInfoView,
            secondArrivalInfoView, alarmBtn
        ].forEach { components in
            totalStack.addArrangedSubview(components)
        }
        
        NSLayoutConstraint.activate([
            totalStack.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 5
            ),
            totalStack.widthAnchor.constraint(
                equalTo: widthAnchor,
                constant: -10
            ),
            totalStack.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            totalStack.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10
            )
        ])
        
    }
}
