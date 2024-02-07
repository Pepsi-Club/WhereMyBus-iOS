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

class BusTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()

    let starBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "star")
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 5,
            bottom: 10,
            trailing: 5
        )
        config.baseForegroundColor = .black
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
            trailing: 5
        )
        config.baseForegroundColor = .black
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
        stack.spacing = 5
        return stack
    }()
    
    private let arrMinStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 5
        return stack
    }()
    
    private let arrStopStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        stack.spacing = 10
        return stack
    }()
    
    private let busNumber: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .bold.font(size: 18)
        label.textColor = .black
        return label
    }()
    
    private let nextStopName: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .bold.font(size: 15)
        label.textColor = .black
        return label
    }()
    
    private let arr1stMsgMin: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .regular.font(size: 15)
        label.textColor = .black
        return label
    }()
    
    private let arr2ndMsgMin: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .regular.font(size: 15)
        label.textColor = .black
        return label
    }()
    
    private let arr1stMsgSt: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .regular.font(size: 11)
        label.textColor = .black
        return label
    }()
    
    private let arr2ndMsgSt: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .regular.font(size: 11)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(
        routeName: String,
        nextRouteName: String,
        firstArrivalTime: String,
        firstArrivalRemaining: String,
        secondArrivalTime: String,
        secondArrivalRemaining: String
    ) {
        busNumber.text = routeName
        nextStopName.text = nextRouteName
        arr1stMsgMin.text = firstArrivalTime
        arr2ndMsgMin.text = secondArrivalTime
        arr1stMsgSt.text = firstArrivalRemaining
        arr2ndMsgSt.text = secondArrivalRemaining
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension BusTableViewCell {
    func configureUI() {
        [starBtn, alarmBtn, totalStack,
         busNumStack, arrMinStack, arrStopStack,
         busNumber, nextStopName, arr1stMsgSt,
         arr1stMsgMin, arr2ndMsgSt, arr2ndMsgMin]
            .forEach { components in
                components.translatesAutoresizingMaskIntoConstraints = false
            }
        
        [busNumber, nextStopName]
            .forEach { components in
                busNumStack.addArrangedSubview(components)
            }
        
        [arr1stMsgMin, arr2ndMsgMin]
            .forEach { components in
                arrMinStack.addArrangedSubview(components)
            }
        
        [arr1stMsgSt, arr2ndMsgSt]
            .forEach { components in
                arrStopStack.addArrangedSubview(components)
            }
        
        [starBtn, busNumStack, arrMinStack, arrStopStack, alarmBtn]
            .forEach { components in
                totalStack.addArrangedSubview(components)
            }
        
        contentView.addSubview(totalStack)
        
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
                equalTo: leadingAnchor,
                constant: 5
            ),
            totalStack.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10
            )
        ])
    }
}
