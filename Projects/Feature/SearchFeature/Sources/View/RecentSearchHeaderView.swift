//
//  SearchTVHeaderView.swift
//  SearchFeature
//
//  Created by gnksbm on 4/3/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

import RxSwift

public final class SearchTVHeaderView: UIView {
    public let actionBtnTapEvent = PublishSubject<Void>()
    public var disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(size: 15)
        label.textColor = .black
        return label
    }()
    
    private let actionBtn: UIButton = {
        let button = UIButton()
        button.titleLabel?.font
        = DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(size: 15)
        button.setTitleColor(
            DesignSystemAsset.gray5.color,
            for: .normal
        )
        button.isHidden = true
        return button
    }()
    
    convenience init(
        title: String,
        btnTitle: String? = nil
    ) {
        self.init()
        titleLabel.text = title
        if let btnTitle {
            actionBtn.setTitle(
                btnTitle,
                for: .normal
            )
            actionBtn.isHidden = false
            actionBtn.rx.tap
                .bind(to: actionBtnTapEvent)
                .disposed(by: disposeBag)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [titleLabel, actionBtn].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 10
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 10
            ),
            titleLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10
            ),
            
            actionBtn.centerYAnchor.constraint(
                equalTo: titleLabel.centerYAnchor
            ),
            actionBtn.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -10
            ),
        ])
    }
}
