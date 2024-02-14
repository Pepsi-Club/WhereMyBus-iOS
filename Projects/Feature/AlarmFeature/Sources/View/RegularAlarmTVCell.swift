//
//  RegularAlarmTVCell.swift
//  AlarmFeature
//
//  Created by gnksbm on 2/13/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem
import Domain

import RxSwift
import RxCocoa

final class RegularAlarmTVCell: UITableViewCell {
    let removeBtnTapEvent = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    private let removeBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        let image = UIImage(systemName: "trash")
        let imgConfig = UIImage.SymbolConfiguration(
            font: .systemFont(ofSize: 20)
        )
        config.image = image
        config.preferredSymbolConfigurationForImage = imgConfig
        config.baseForegroundColor = DesignSystemAsset.gray5.color
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let busInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let alarmInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [busInfoLabel, alarmInfoLabel]
        )
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.addDivider(
            color: DesignSystemAsset.weekDayGray.color,
            hasPadding: true,
            dividerRatio: 1
        )
        stackView.backgroundColor = DesignSystemAsset.regularAlarmSky.color
        stackView.layer.cornerRadius = 10
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        busInfoLabel.attributedText = nil
        alarmInfoLabel.attributedText = nil
    }
    
    func updateUI(response: RegularAlarmResponse) {
        let weekDayMessage = response.weekDay.compactMap {
            AddRegularAlarmViewController.WeekDay(rawValue: $0)?.toString
        }.joined(separator: ", ")
        updateAlarm(
            weekDay: weekDayMessage,
            time: response.time.toString(dateFormat: "hhmma")
        )
        updateBusInfo(
            busStop: response.busStopName,
            bus: response.busName
        )
    }
    
    private func updateAlarm(
        weekDay: String,
        time: String
    ) {
        let weekDayString = NSAttributedString(
            string: weekDay + "\n",
            attributes: [
                .font: DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
                    size: 15
                ),
                .foregroundColor: DesignSystemAsset.lightRed.color
            ]
        )
        let timeString = NSAttributedString(
            string: time,
            attributes: [
                .font: DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(
                    size: 15
                ),
                .foregroundColor: UIColor.black
            ]
        )
        let attrString = NSMutableAttributedString()
        attrString.append(weekDayString)
        attrString.append(timeString)
        alarmInfoLabel.attributedText = attrString
    }
    
    private func updateBusInfo(
        busStop: String,
        bus: String
    ) {
        let busStopString = NSAttributedString(
            string: busStop + "\n",
            attributes: [
                .font: DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(
                    size: 26
                ),
                .foregroundColor: DesignSystemAsset.regularAlarmBlue.color
            ]
        )
        let busString = NSAttributedString(
            string: bus,
            attributes: [
                .font: DesignSystemFontFamily.NanumSquareNeoOTF.light.font(
                    size: 12
                ),
                .foregroundColor: UIColor.black
            ]
        )
        let attrString = NSMutableAttributedString()
        attrString.append(busStopString)
        attrString.append(busString)
        busInfoLabel.attributedText = attrString
    }
    
    private func configureUI() {
        backgroundColor = .clear
        [removeBtn, stackView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            removeBtn.topAnchor.constraint(equalTo: contentView.topAnchor),
            removeBtn.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            
            stackView.topAnchor.constraint(equalTo: removeBtn.bottomAnchor),
            stackView.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),
            stackView.widthAnchor.constraint(
                equalTo: contentView.widthAnchor,
                multiplier: 0.9
            ),
            stackView.heightAnchor.constraint(
                equalToConstant: 95
            ),
            stackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
        ])
    }
    
    private func bind() {
        removeBtn.rx.tap
            .bind(to: removeBtnTapEvent)
            .disposed(by: disposeBag)
    }
}
