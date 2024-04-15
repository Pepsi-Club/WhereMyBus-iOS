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
	
	// MARK: - UI Property
	
	private let symbolSize = 50
	
	private let busStopSymbol: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DesignSystemAsset.bigBusStop.image
        return imageView
	}()
	
    private let busStopNameLabel: UILabel = {
		let label = UILabel()
		label.font = DesignSystemFontFamily.NanumSquareNeoOTF.extraBold.font(
			size: 15
		)
        label.textColor = .black
		return label
	}()
	
    private let busStopDescription: UILabel = {
		let label = UILabel()
		label.font = DesignSystemFontFamily.NanumSquareNeoOTF.light.font(
            size: 13
        )
        label.adjustsFontForContentSizeCategory = true
        label.minimumScaleFactor = 0.8
        label.textColor = .black
		return label
	}()
	
    private let distanceStringLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF.light.font(
            size: 13
        )
        label.text = "현재 위치에서 약 "
        label.textColor = .black
        return label
    }()
    
    private let distanceFromBusStopLabel: UILabel = {
		let label = UILabel()
		label.font = DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(
			size: 13
		)
        label.textColor = DesignSystemAsset.lightRed.color
		return label
	}()
    
    private let distanceStringLabel2: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF.light.font(
            size: 13
        )
        label.text = " 떨어져 있어요"
        label.textColor = .black
        return label
    }()
	
    private let separationView: UIView = {
		let view = UIView()
        view.backgroundColor = .black
		return view
	}()
	
	private lazy var busStopNameStackView: UIStackView = {
		let stackView = UIStackView(
			arrangedSubviews: [
                busStopNameLabel,
                busStopDescription,
            ]
		)
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.alignment = .leading
		stackView.spacing = 3
		return stackView
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
	
	// MARK: - Life Cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Function
	
	private func configureUI() {
        self.backgroundColor = .white
		
		[
			busStopSymbol,
			busStopNameStackView,
			distancStackView,
			separationView,
		].forEach {
			self.addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}
		
		NSLayoutConstraint.activate([
			
			// busStopSymbol
			busStopSymbol.topAnchor.constraint(
				equalTo: self.topAnchor,
				constant: 20
			),
			busStopSymbol.leftAnchor.constraint(
				equalTo: self.leftAnchor,
				constant: 20
			),
			busStopSymbol.heightAnchor.constraint(
				equalToConstant: CGFloat(symbolSize)
			),
			busStopSymbol.widthAnchor.constraint(
				equalToConstant: CGFloat(symbolSize)
			),
            busStopSymbol.bottomAnchor.constraint(
                equalTo: separationView.topAnchor,
                constant: 0
            ),
			
			// busStopNameStackView
			busStopNameStackView.topAnchor.constraint(
				equalTo: self.topAnchor,
				constant: 20
			),
			busStopNameStackView.leftAnchor.constraint(
				equalTo: busStopSymbol.rightAnchor,
				constant: 15
			),
			busStopNameStackView.rightAnchor.constraint(
				equalTo: self.rightAnchor,
				constant: -10
			),
			busStopNameStackView.heightAnchor.constraint(
				equalToConstant: CGFloat(symbolSize)
			),
			
			// separationView
			separationView.topAnchor.constraint(
				equalTo: busStopNameStackView.bottomAnchor,
				constant: 10
			),
			separationView.leftAnchor.constraint(
				equalTo: self.leftAnchor,
				constant: 15
			),
			separationView.rightAnchor.constraint(
				equalTo: self.rightAnchor,
				constant: -10
			),
			separationView.heightAnchor.constraint(
                equalToConstant: 1
			),
			
			// distanceFromBusStopLabel
            distancStackView.topAnchor.constraint(
				equalTo: separationView.bottomAnchor,
				constant: 10
			),
            distancStackView.leftAnchor.constraint(
				equalTo: self.leftAnchor,
				constant: 20 + CGFloat(symbolSize) + 15
			)
		])
		
	}
    
    func updateUI(response: BusStopInfoResponse, distance: String) {
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
