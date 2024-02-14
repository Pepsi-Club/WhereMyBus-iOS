//
//  AlarmSettingViewController.swift
//  SettingsFeature
//
//  Created by 유하은 on 2024/02/14.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//
import UIKit

import DesignSystem

import RxSwift

public final class AlarmSettingViewController: UIViewController {
    
// private let viewModel: SettingsViewModel

//    public init(viewModel: SettingsViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }

    private let settingAlarmViewCell = SettingAlarmViewCell()
    
    // 알람뷰셀과 timeLabel 스택
    private let alarmStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        stack.spacing = 10
        return stack
    }()
    
    // alarmSettingLabel 1 & 2 의 스택
    private let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 0
        return stack
    }()
    
    // labelStack과 busImg의 스택
    private let labelImgStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
            size: 18
        )
        label.textColor =
            DesignSystemAsset.gray6.color
        
        return label
    }()
    
    private let alarmSettingLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.extraBold.font(size: 17)
        label.text = "버스 도착 알림"
        return label
    }()
    
    private let alarmSettingLabel2: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 16)
        label.text = "을\n몇 분 전에 울릴까요?"
        return label
    }()
    
    // MARK: 이렇게 까지 해야하나..?
    private let busImg: UIImage = {
        if let image = UIImage(named: "bus2") {
            let newSize = CGSize(width: 20, height: 20)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage ?? image
        } else {
            fatalError("Image not found.")
        }
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        [settingAlarmViewCell, alarmStack, labelStack, labelImgStack,
         timeLabel, alarmSettingLabel, alarmSettingLabel2, ]
            .forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [settingAlarmViewCell, timeLabel]
                    .forEach { components in
                        alarmStack
                            .addArrangedSubview(components)
                    }
        [alarmSettingLabel, alarmSettingLabel2]
                    .forEach { components in
                        labelStack
                            .addArrangedSubview(components)
                    }
        [timeLabel, alarmStack]
            .forEach { components in
                labelImgStack
                    .addArrangedSubview(components)
                }
        
        NSLayoutConstraint.activate([
            
            // MARK: 굳이 없어도 되는 오토레이아웃이 있는가? 얘를 들어 labelStack
            labelStack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: 50),
            labelStack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: 50),
            labelStack.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            
            labelImgStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelImgStack.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 30),
            
            alarmStack.topAnchor.constraint(equalTo: labelImgStack.bottomAnchor,
                                            constant: 30),
            alarmStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
                ])
        
}
            }
