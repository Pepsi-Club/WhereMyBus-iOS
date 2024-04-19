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

public final class BusStopInformationView: UIView {
	private let symbolSize = 50
	
	private let busStopSymbol: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DesignSystemAsset.bigBusStop.image
        return imageView
	}()
	
    private let busStopNameLabel: UILabel = {
		let label = UILabel()
        label.font = .nanumExtraBold(size: 15)
        label.textColor = .black
		return label
	}()
	
    private let busStopDescription: UILabel = {
		let label = UILabel()
        label.font = .nanumLight(size: 13)
        label.adjustsFontForContentSizeCategory = true
        label.minimumScaleFactor = 0.8
        label.textColor = .black
		return label
	}()
	
    private let distanceStringLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumLight(size: 13)
        label.text = "현재 위치에서 약 "
        label.textColor = .black
        return label
    }()
    
    private let distanceFromBusStopLabel: UILabel = {
		let label = UILabel()
        label.font = .nanumBold(size: 13)
        label.textColor = DesignSystemAsset.lightRed.color
		return label
	}()
    
    private let distanceStringLabel2: UILabel = {
        let label = UILabel()
        label.font = .nanumLight(size: 13)
        label.text = " 떨어져 있어요"
        label.textColor = .black
        return label
    }()
	
    private let separationView: UIView = {
		let view = UIView()
        view.backgroundColor = .black
		return view
	}()
	
    private lazy var distancStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                distanceStringLabel,
                distanceFromBusStopLabel,
                distanceStringLabel2
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
        backgroundColor = DesignSystemAsset.gray1.color
		
		[
			busStopSymbol,
            busStopNameLabel,
            busStopDescription,
			distancStackView,
			separationView,
		].forEach {
			addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}
		
		NSLayoutConstraint.activate([
			busStopSymbol.leadingAnchor.constraint(
				equalTo: leadingAnchor,
				constant: 20
			),
			busStopSymbol.heightAnchor.constraint(
				equalToConstant: symbolSize.f
			),
			busStopSymbol.widthAnchor.constraint(
				equalToConstant: symbolSize.f
			),
            busStopSymbol.bottomAnchor.constraint(
                equalTo: separationView.topAnchor
            ),
            
            busStopNameLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 25
            ),
            busStopNameLabel.leadingAnchor.constraint(
                equalTo: busStopSymbol.trailingAnchor,
                constant: 15
            ),
            busStopNameLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -10
            ),
            
            busStopDescription.topAnchor.constraint(
                equalTo: busStopNameLabel.bottomAnchor,
                constant: 5
            ),
            busStopDescription.leadingAnchor.constraint(
                equalTo: busStopNameLabel.leadingAnchor
            ),
            busStopDescription.trailingAnchor.constraint(
                equalTo: busStopNameLabel.trailingAnchor
            ),
			
			separationView.topAnchor.constraint(
				equalTo: busStopDescription.bottomAnchor,
				constant: 10
			),
			separationView.leadingAnchor.constraint(
				equalTo: leadingAnchor,
				constant: 15
			),
			separationView.trailingAnchor.constraint(
				equalTo: trailingAnchor,
				constant: -10
			),
			separationView.heightAnchor.constraint(
                equalToConstant: 1
			),
			
            distancStackView.topAnchor.constraint(
				equalTo: separationView.bottomAnchor,
				constant: 10
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
