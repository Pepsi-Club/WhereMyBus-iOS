//
//  BusStopInfoView.swift
//  SearchFeature
//
//  Created by gnksbm on 4/4/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem
import Domain

public final class BusStopInfoView: UIView {
    private let busStopNameLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumRegular(size: 16)
        label.textAlignment = .left
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumRegular(size: 13)
        label.textAlignment = .left
        label.textColor = DesignSystemAsset.gray5.color
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func prepareForReuse() {
        [busStopNameLabel, descriptionLabel].forEach {
            $0.attributedText = nil
        }
    }
    
    public func updateUI(
        response: BusStopInfoResponse,
        searchKeyword: String
    ) {
        let attributedBusStopName = NSMutableAttributedString(
            string: response.busStopName
        )
        if let boldNameRange = response.busStopName.range(
            of: searchKeyword,
            options: .caseInsensitive
        ) {
            attributedBusStopName.addAttribute(
                .font,
                value: UIFont.nanumBold(size: 16),
                range: NSRange(
                    boldNameRange,
                    in: response.busStopName
                )
            )
        }
        
        let attributedDescription = NSMutableAttributedString(
            string: "\(response.busStopId) | \(response.direction) 방면"
        )
        
        if let boldDescriptionRange = response.busStopId.range(
            of: searchKeyword,
            options: .caseInsensitive
        ) {
            attributedDescription.addAttributes(
                [
                    .font: UIFont.nanumBold(size: 13),
                    .foregroundColor: UIColor.black
                ],
                range: NSRange(
                    boldDescriptionRange,
                    in: response.busStopId
                )
            )
        }
        
        busStopNameLabel.attributedText = attributedBusStopName
        descriptionLabel.attributedText = attributedDescription
    }
    
    private func configureUI() {
        backgroundColor = .white
        [busStopNameLabel, descriptionLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            busStopNameLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 15
            ),
            busStopNameLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 15
            ),
            busStopNameLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -15
            ),
            
            descriptionLabel.topAnchor.constraint(
                equalTo: busStopNameLabel.bottomAnchor,
                constant: 6
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: busStopNameLabel.leadingAnchor
            ),
            descriptionLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -15
            ),
        ])
    }
}
