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

import RxSwift

internal final class FavoritesHeaderView: UITableViewHeaderFooterView {
    var disposeBag = DisposeBag()
    private let busStopNameLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(
            size: 16
        )
        label.textAlignment = .left
        label.textColor = DesignSystemAsset.settingColor.color
        return label
    }()
    
    private let directionLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
            size: 13
        )
        label.textAlignment = .left
        label.textColor = .gray
        return label
    }()
    
    private let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystemAsset.gray4Minor.color
        return view
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
        contentView.backgroundColor =
        DesignSystemAsset.tableViewColor.color
        
        [busStopNameLabel, directionLabel, dividerLine].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            busStopNameLabel.leadingAnchor.constraint(
                equalTo: directionLabel.leadingAnchor
            ),
            busStopNameLabel.bottomAnchor.constraint(
                equalTo: directionLabel.topAnchor,
                constant: -5
            ),
            busStopNameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -20
            ),
            
            directionLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 20
            ),
            directionLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10
            ),
            
            dividerLine.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 10
            ),
            dividerLine.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10
            ),
            dividerLine.heightAnchor.constraint(equalToConstant: 1),
            dividerLine.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
        ])
    }
    
    func updateUI(
        name: String?,
        direction: String?
    ) {
        busStopNameLabel.text = name
        if let direction {
            directionLabel.text = direction + " 방면"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [busStopNameLabel, directionLabel].forEach {
            $0.text = nil
        }
    }
}
