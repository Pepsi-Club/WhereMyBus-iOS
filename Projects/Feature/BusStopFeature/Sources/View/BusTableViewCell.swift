//
//  BusTableViewCell.swift
//  BusStopFeatureDemo
//
//  Created by Jisoo HAM on 2/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

import RxSwift

public final class BusTableViewCell: UITableViewCell {
    public var disposeBag = DisposeBag()
    
    private let firstArrivalInfoView = ArrivalInfoView()
    private let secondArrivalInfoView = ArrivalInfoView()
    public let starBtnTapEvent = PublishSubject<Void>()
    public let alarmBtnTapEvent = PublishSubject<Void>()
    
    private lazy var starBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "star")
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 15,
            bottom: 10,
            trailing: 5
        )
        let imgConfig = UIImage.SymbolConfiguration(
            font: .systemFont(ofSize: 13)
        )
        config.preferredSymbolConfigurationForImage = imgConfig
        config.baseForegroundColor = DesignSystemAsset.mainColor.color
        let btn = UIButton(configuration: config)
        return btn
    }()
    
    private lazy var alarmBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        let imgConfig = UIImage.SymbolConfiguration(
            pointSize: 12
        )
        config.preferredSymbolConfigurationForImage = imgConfig
        config.baseForegroundColor = DesignSystemAsset.mainColor.color
        let btn = UIButton(configuration: config)
        btn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        btn.isHidden = true
        return btn
    }()
    
    private let totalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    private let busNumStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
        stack.spacing = 3
        return stack
    }()
    
    public let busNumber: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .bold.font(size: 18)
        label.textColor = DesignSystemAsset.blueBus.color
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return label
    }()
    
    private let nextStopName: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .regular.font(size: 14)
        label.textColor = DesignSystemAsset.remainingColor.color
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        configureUI()
        buttonTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateBtn(
        favorite: Bool,
        alarm: Bool
    ) {
        changeFavBtnColor(isFavoriteOn: favorite)
        changeAlarmBtnColor(isAlarmOn: alarm)
    }
    
    public func updateBusRoute(
        routeName: String,
        nextRouteName: String
    ) {
        busNumber.text = routeName
        nextStopName.text = nextRouteName
    }
    
    public func updateFirstArrival(
        firstArrivalTime: String,
        firstArrivalRemaining: String
    ) {
        firstArrivalInfoView.updateUI(
            time: firstArrivalTime, remainingStops: firstArrivalRemaining
        )
    }
    
    public func updateSecondArrival(
        secondArrivalTime: String,
        secondArrivalRemaining: String
    ) {
        secondArrivalInfoView.updateUI(
            time: secondArrivalTime, remainingStops: secondArrivalRemaining
        )
    }
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        [busNumber, nextStopName].forEach {
            $0.text = nil
        }
        [firstArrivalInfoView, secondArrivalInfoView].forEach {
            $0.updateUI(time: "", remainingStops: "")
        }
        
        disposeBag = DisposeBag()
        buttonTap()
    }
    
    private func buttonTap() {
        starBtn.rx.tap
            .map({ _ in
                print("🤮TAP")
            })
            .subscribe(onNext: { _ in
                self.starBtnTapEvent.onNext(())
            })
            .disposed(by: disposeBag)
        
//        alarmBtn.rx.tap
//            .map({ _ in
//                print("🤮TAP")
//            })
//            .subscribe(onNext: { _ in
//                self.alarmBtnTapEvent.onNext(())
//            })
//            .disposed(by: disposeBag)
    }
    
    private func changeFavBtnColor(isFavoriteOn: Bool) {
        
        guard var config = starBtn.configuration
        else { return }
        
        config.image = isFavoriteOn
        ? UIImage(systemName: "star.fill")
        : UIImage(systemName: "star")
        
        config.baseForegroundColor
        = isFavoriteOn
        ? DesignSystemAsset.carrotOrange.color
        : DesignSystemAsset.mainColor.color
        
        starBtn.configuration = config
    }
    
    private func changeAlarmBtnColor(isAlarmOn: Bool) {
        guard var config = alarmBtn.configuration
        else { return }
        
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 5,
            bottom: 10,
            trailing: 10
        )
        
        config.image = isAlarmOn
        ? UIImage(systemName: "alarm.waves.left.and.right.fill")
        : UIImage(systemName: "alarm")
        
        config.baseForegroundColor = isAlarmOn
        ? DesignSystemAsset.carrotOrange.color
        : DesignSystemAsset.mainColor.color
        
        alarmBtn.configuration = config
    }
}

extension BusTableViewCell {
    private func configureUI() {
        contentView.addSubview(totalStack)
        
        [
            starBtn, alarmBtn, busNumStack,
            totalStack, busNumber, nextStopName,
            firstArrivalInfoView, secondArrivalInfoView
        ].forEach { components in
            components.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            busNumber, nextStopName
        ].forEach { components in
            busNumStack.addArrangedSubview(components)
        }
        
        [
            starBtn, busNumStack, firstArrivalInfoView,
            secondArrivalInfoView, alarmBtn
        ].forEach { components in
            totalStack.addArrangedSubview(components)
        }
        
        NSLayoutConstraint.activate([
            busNumStack.widthAnchor.constraint(equalToConstant: 110),
            firstArrivalInfoView.widthAnchor.constraint(equalToConstant: 60),
            totalStack.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 5
            ),
            totalStack.widthAnchor.constraint(
                equalTo: widthAnchor,
                constant: -10
            ),
            totalStack.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            totalStack.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10
            )
        ])
        
    }
}
