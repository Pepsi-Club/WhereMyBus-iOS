//
//  BusStopInformationView.swift
//  NearMapFeatureDemo
//
//  Created by Muker on 2/7/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem
import Domain

import Lottie

public final class BusStopInformationView: UIView {
    private let symbolSize = 50
    
    private let birdLottieView: LottieAnimationView = {
        let imgView = LottieAnimationView(
            name: "goingBus",
            configuration: LottieConfiguration(renderingEngine: .mainThread)
        )
        imgView.setting()
        return imgView
    }()
    
    private let busStopNameLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumExtraBold(size: 18)
        label.textColor = .adaptiveBlack.withAlphaComponent(0.8)
        return label
    }()
    
    private let busStopDescription: UILabel = {
        let label = UILabel()
        label.font = .nanumRegular(size: 13)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = .adaptiveBlack.withAlphaComponent(0.8)
        return label
    }()
    
    private let distanceStringLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumLight(size: 13)
        label.text = "현재 위치에서 약 "
        label.textColor = .adaptiveBlack.withAlphaComponent(0.8)
        return label
    }()
    
    private let distanceFromBusStopLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumExtraBold(size: 12)
        label.textColor = .adaptiveWhite
        label.backgroundColor = DesignSystemAsset.carrotOrange.color
        label.clipsToBounds = true
        label.textAlignment = .center

        label.widthAnchor.constraint(equalToConstant: 65).isActive = true
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        label.layer.cornerRadius = 10

        return label
    }()
    
    private let distanceStringLabel2: UILabel = {
        let label = UILabel()
        label.font = .nanumLight(size: 13)
        label.text = " 떨어져 있어요"
        label.textColor = .adaptiveBlack
        return label
    }()
    
    private let separationView: UIView = {
        let view = UIView()
        view.backgroundColor = .adaptiveBlack
        return view
    }()
    
    private lazy var distancStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                // distanceStringLabel,
                distanceFromBusStopLabel,
                // distanceStringLabel2
            ]
        )
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 1
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
        backgroundColor = .adaptiveWhite
        
        [
            busStopNameLabel,
            busStopDescription,
            distancStackView,
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            busStopNameLabel.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
            busStopNameLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 15
            ),
            busStopNameLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -15
            ),
            
            busStopDescription.leadingAnchor.constraint(
                equalTo: busStopNameLabel.leadingAnchor
            ),
            busStopDescription.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -15
            ),
            busStopDescription.topAnchor.constraint(
                equalTo: busStopNameLabel.bottomAnchor,
                constant: 5
            ),
            
            distancStackView.topAnchor.constraint(
                equalTo: busStopNameLabel.topAnchor,
                constant: -40
            ),
            distancStackView.leadingAnchor.constraint(
                equalTo: busStopNameLabel.leadingAnchor
            ),
        ])
        
    }
    
    func updateUI(
        response: BusStopInfoResponse,
        distance: String
    ) {
        busStopNameLabel.text = response.busStopName
        if !response.busStopId.isEmpty && !response.direction.isEmpty {
        }
        var description = ""
        if !response.busStopId.isEmpty {
            if !response.direction.isEmpty {
                description
                = "\(response.busStopId) | \(response.direction) 방면"
            } else {
                description = "\(response.busStopId)"
            }
        }
        busStopDescription.text = description
        distanceFromBusStopLabel.text = distance
    }
}
