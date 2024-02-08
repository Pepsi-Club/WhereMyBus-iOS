//
//  NearBusStopLabel.swift
//  NearMapFeatureDemo
//
//  Created by Muker on 2/7/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

public final class NearBusStopLabel: UIView {
	
	// MARK: - property
	
	private let symbolSize = 50
	
	private lazy var busStopSymbol: UIImageView = {
		let image = UIImageView(
			image: UIImage(systemName: "mappin.and.ellipse")!
		)
		image.tintColor = .darkGray
		return image
	}()
	
	private lazy var busStopNameLabel: UILabel = {
		let label = UILabel()
		label.text = "강남구 보건소"
		label.font = DesignSystemFontFamily.NanumSquareNeoOTF.extraBold.font(
			size: 15
		)
		return label
	}()
	
	private lazy var busStopDescription: UILabel = {
		let label = UILabel()
		label.text = "23290 | 강남구청역 방면"
		label.font = DesignSystemFontFamily.NanumSquareNeoOTF.light.font(
			size: 13
		)
		return label
	}()
	
	private lazy var distanceFromBusStopLabel: UILabel = {
		let label = UILabel()
		label.text = "현재위치에서 1m"
		label.font = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
			size: 13
		)
		return label
	}()
	
	private lazy var separationView: UIView = {
		let view = UIView()
		view.backgroundColor = .systemGray4
		return view
	}()
	
	private lazy var busStopNameStackView: UIStackView = {
		let stackView = UIStackView(
			arrangedSubviews: [busStopNameLabel,
							   busStopDescription]
		)
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.alignment = .leading
		stackView.spacing = 3
		return stackView
	}()
	
	// MARK: - life cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - function
	
	private func configureUI() {
		self.backgroundColor = .systemGray6
		
		[
			busStopSymbol,
			busStopNameStackView,
			distanceFromBusStopLabel,
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
				constant: 20
			),
			separationView.rightAnchor.constraint(
				equalTo: self.rightAnchor,
				constant: -10
			),
			separationView.heightAnchor.constraint(
				equalToConstant: 1
			),
			
			// distanceFromBusStopLabel
			distanceFromBusStopLabel.topAnchor.constraint(
				equalTo: separationView.bottomAnchor,
				constant: 10
			),
			distanceFromBusStopLabel.leftAnchor.constraint(
				equalTo: self.leftAnchor,
				constant: 20 + CGFloat(symbolSize) + 15
			),
			distanceFromBusStopLabel.rightAnchor.constraint(
				equalTo: self.rightAnchor,
				constant: -10
			),
		])
		
	}
	
}
