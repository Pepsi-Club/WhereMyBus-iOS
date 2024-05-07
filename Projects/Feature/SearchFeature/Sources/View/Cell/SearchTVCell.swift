//
//  RecentSearchCell.swift
//  SearchFeature
//
//  Created by 유하은 on 2024/02/27.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core
import DesignSystem
import Domain

import RxSwift

final class SearchTVCell: UITableViewCell {
    let cellTapEvent = PublishSubject<BusStopInfoResponse>()
    var disposeBag = DisposeBag()
    
    private let busStopInfoView = BusStopInfoView()
    
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
    }

    private func configureUI() {
        backgroundColor = .adaptiveWhite
        
        [busStopInfoView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            busStopInfoView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            busStopInfoView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            busStopInfoView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            busStopInfoView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
        ])
    }
}
