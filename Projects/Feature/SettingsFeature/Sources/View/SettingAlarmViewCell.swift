//
//  SettingAlarmViewCell.swift
//  SettingsFeature
//
//  Created by 유하은 on 2024/02/14.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

import RxSwift

final class SettingAlarmViewCell: UITableViewCell {
    private var disposeBag = DisposeBag()
    
    private let squareRect: UIView = {
        let squareView = UIView()
        squareView.frame = CGRect(x: 50, y: 50, width: 73, height: 25)
        squareView.layer.cornerRadius = 15
        squareView.backgroundColor = DesignSystemAsset.gray4.color

        return squareView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI(){
        
    }
    
    private func configureUI() {
        
    }
}
