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
        let image = UIImage(systemName: "minus.circle.fill")
        let imgConfig = UIImage.SymbolConfiguration(
            font: .systemFont(ofSize: 16)
        )
        config.image = image
        config.preferredSymbolConfigurationForImage = imgConfig
        config.baseForegroundColor = DesignSystemAsset.lightRed.color
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let busInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    private let alarmInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
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
            color: DesignSystemAsset.gray2.color,
            hasPadding: true,
            dividerRatio: 0.8
        )
        stackView.backgroundColor = DesignSystemAsset.bottonBtnColor.color
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
        let weekDayMessage = response.weekday
            .sorted()
            .compactMap {
                AddRegularAlarmViewController.WeekDay(rawValue: $0)?.toString
            }
            .joined(separator: ", ")
        var timeMessage = response.time.toString(dateFormat: "a hh시 mm분")
        timeMessage.replace("AM", with: "오전")
        timeMessage.replace("PM", with: "오후")
        updateAlarm(
            weekDay: weekDayMessage,
            time: timeMessage
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
            string: "매주 \(weekDay)요일\n",
            attributes: [
                .font: DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
                    size: 15
                ),
                .foregroundColor: DesignSystemAsset.lightRed.color
            ]
        )
        let divider = NSAttributedString(
            string: " \n",
            attributes: [
                .font: DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(
                    size: 5
                ),
                .foregroundColor: DesignSystemAsset.gray1.color
            ]
        )
        let timeString = NSAttributedString(
            string: time,
            attributes: [
                .font: DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(
                    size: 17
                ),
                .foregroundColor: DesignSystemAsset.gray1.color
            ]
        )
        let attrString = NSMutableAttributedString()
        attrString.append(weekDayString)
        attrString.append(divider)
        attrString.append(timeString)
        alarmInfoLabel.attributedText = attrString
    }
    
    private func updateBusInfo(
        busStop: String,
        bus: String
    ) {
        let busString = NSAttributedString(
            string: bus + "\n",
            attributes: [
                .font: DesignSystemFontFamily.NanumSquareNeoOTF.extraBold.font(
                    size: 23
                ),
                .foregroundColor: DesignSystemAsset.gray1.color
            ]
        )
        let divider = NSAttributedString(
            string: " \n",
            attributes: [
                .font: DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(
                    size: 3
                ),
                .foregroundColor: UIColor.white
            ]
        )
        let busStopString = NSAttributedString(
            string: busStop,
            attributes: [
                .font: DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
                    size: 14
                ),
                .foregroundColor: DesignSystemAsset.gray1.color
            ]
        )
        let attrString = NSMutableAttributedString()
        attrString.append(busString)
        attrString.append(divider)
        attrString.append(busStopString)
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
