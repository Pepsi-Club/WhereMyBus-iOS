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
    //    public let starBtnTapEvent = PublishSubject<Void>()
    public let starBtnTapEvent = BehaviorSubject<Bool>(value: false)
    public let alarmBtnTapEvent = PublishSubject<Void>()
    
    private var favoriteToggle = false
    private var alarmToggle = false
    
    private lazy var starBtn: UIButton = {
        var config = UIButton.Configuration.filled()
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
        config.baseBackgroundColor = .clear
        let btn = UIButton(configuration: config)
        return btn
    }()
    
    private lazy var alarmBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "alarm")
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 5,
            bottom: 10,
            trailing: 15
        )
        let imgConfig = UIImage.SymbolConfiguration(
            font: .systemFont(ofSize: 13)
        )
        config.preferredSymbolConfigurationForImage = imgConfig
        config.baseForegroundColor = DesignSystemAsset.mainColor.color
        config.baseBackgroundColor = .clear
        let btn = UIButton(configuration: config)
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
        return label
    }()
    
    private let nextStopName: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .regular.font(size: 14)
        label.textColor = DesignSystemAsset.remainingColor.color
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
        favoriteToggle = favorite
        alarmToggle = alarm
        
        changeFavBtnColor(isFavoriteOn: favoriteToggle)
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
    }
    
    private func buttonTap() {
        starBtn.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                
                favoriteToggle = !favoriteToggle
                
                changeFavBtnColor(isFavoriteOn: favoriteToggle)
                
                self.starBtnTapEvent.onNext((favoriteToggle))
                
                print(" 즐겨찾기 버튼 작동 ")
            })
            .disposed(by: disposeBag)
        
        alarmBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.alarmBtnTapEvent.onNext(())
                print(" 알람 버튼 작동 ")
            })
            .disposed(by: disposeBag)
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
