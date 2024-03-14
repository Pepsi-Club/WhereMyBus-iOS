//
//  RegularAlarmForBusTableViewCell.swift
//  BusStopFeature
//
//  Created by Jisoo HAM on 3/4/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

import RxSwift

public final class RegularAlarmForBusTableViewCell: UITableViewCell {
    public var disposeBag = DisposeBag()
    
    public var busNumberLb: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .bold.font(size: 16)
        label.textColor = DesignSystemAsset.blueBus.color
        return label
    }()
    
    private var nextStationLb: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .bold.font(size: 16)
        label.textColor = DesignSystemAsset.remainingColor.color
        return label
    }()
    
    private var nextSymbol: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(
            pointSize: 16,
            weight: .regular
        )
        let img = UIImage(
            systemName: "chevron.right",
            withConfiguration: configuration
        )
        let image = UIImageView(image: img)
        image.tintColor = DesignSystemAsset.remainingColor.color
        return image
    }()
    
    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    override public init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        [busNumberLb, nextStationLb]
            .forEach { $0.text = "" }

        disposeBag = DisposeBag()
    }
    
    public func updateUI(
        busNumber: String,
        nextStopName: String
    ) {
        busNumberLb.text = busNumber
        nextStationLb.text = nextStopName
    }
    
    private func configureUI() {
        [busNumberLb, nextStationLb, nextSymbol]
            .forEach { component in
                component.translatesAutoresizingMaskIntoConstraints = false
                addSubview(component)
            }
        
        NSLayoutConstraint.activate([
            busNumberLb.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 20
            ),
            nextStationLb.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 20
            ),
            nextSymbol.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 20
            ),
            busNumberLb.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 30
            ),
            nextStationLb.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextSymbol.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -30
            ),
        ])
        
    }
}
