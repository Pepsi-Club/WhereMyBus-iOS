//
//  FavoritesHeaderView.swift
//  HomeFeatureDemo
//
//  Created by gnksbm on 1/23/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core
import DesignSystem

internal final class FavoritesHeaderView: UITableViewHeaderFooterView {
    private let stationNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    private let directionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .left
        label.textColor = .gray
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addCornerRadius(
            corners: [.topLeft, .topRight]
        )
    }
    
    private func configureUI() {
        contentView.backgroundColor = DesignSystemAsset.gray1.color
        
        [stationNameLabel, directionLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stationNameLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 10
            ),
            stationNameLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 10
            ),
            stationNameLabel.bottomAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            
            directionLabel.leadingAnchor.constraint(
                equalTo: stationNameLabel.leadingAnchor
            ),
            directionLabel.topAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            directionLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -5
            ),
        ])
    }
    
    func updateUI(
        name: String,
        direction: String
    ) {
        stationNameLabel.text = name
        directionLabel.text = direction
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [stationNameLabel, directionLabel].forEach {
            $0.text = nil
        }
    }
}
