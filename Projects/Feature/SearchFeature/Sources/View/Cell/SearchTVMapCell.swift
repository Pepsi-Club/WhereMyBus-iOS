//
//  SearchTVMapCell.swift
//  SearchFeature
//
//  Created by gnksbm on 4/4/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core
import DesignSystem
import Domain

import RxSwift

final class SearchTVMapCell: UITableViewCell {
    let cellTapEvent = PublishSubject<BusStopInfoResponse>()
    let mapBtnTapEvent = PublishSubject<String>()
    var disposeBag = DisposeBag()
    
    private let imgFontSize = 16
    private let busStopInfoView = BusStopInfoView()
    private lazy var mapBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "map")?
            .withConfiguration(
                UIImage.SymbolConfiguration(
                    font: .systemFont(ofSize: imgFontSize.f)
                )
            )
        let button = UIButton(configuration: config)
        button.tintColor = DesignSystemAsset.accentColor.color
        return button
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        busStopInfoView.prepareForReuse()
        disposeBag = .init()
    }
    
    public func updateUI(
        response: BusStopInfoResponse,
        searchKeyword: String
    ) {
        busStopInfoView.updateUI(
            response: response,
            searchKeyword: searchKeyword
        )
        bindTapGesture(response: response)
    }
    
    private func bindTapGesture(response: BusStopInfoResponse) {
        let tapGesture = UITapGestureRecognizer()
        contentView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .map { _ in
                response
            }
            .bind(to: cellTapEvent)
            .disposed(by: disposeBag)
        
        mapBtn.rx.tap
            .map { _ in
                response.busStopId
            }
            .bind(to: mapBtnTapEvent)
            .disposed(by: disposeBag)
    }

    private func configureUI() {
        backgroundColor = .white

        [busStopInfoView, mapBtn].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            mapBtn.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            mapBtn.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -30
            ),
            mapBtn.widthAnchor.constraint(
                equalToConstant: imgFontSize.f
            ),
            
            busStopInfoView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            busStopInfoView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            busStopInfoView.trailingAnchor.constraint(
                equalTo: mapBtn.leadingAnchor,
                constant: -15
            ),
            busStopInfoView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
        ])
    }
}
