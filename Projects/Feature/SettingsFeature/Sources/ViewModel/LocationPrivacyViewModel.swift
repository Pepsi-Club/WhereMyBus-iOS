//
//  LocationPrivacyViewModel.swift
//  SettingsFeature
//
//  Created by Jisoo Ham on 2024/02/27.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain
import FeatureDependency

import RxSwift

public final class LocationPrivacyViewModel: ViewModel {
    private let coordinator: SettingsCoordinator
    private let disposeBag = DisposeBag()
    
    public init(coordinator: SettingsCoordinator) {
        self.coordinator = coordinator
    }
    
    deinit {
        print("viewmodel deinit?")
    }
    
    public func transform(input: Input) -> Output {
        let output = Output(
            locationPrivacyString: .init()
        )
        
        input.viewWillAppearEvent
            .subscribe(onNext: {
                // MARK: - config + info plist에 있는 값을 가져오는 방식에서 문제인건지 계속 else로 빠짐
                if let locationURL = Bundle.main.object(forInfoDictionaryKey: "LOCATION_PRIVACY_URL") as? String {
                    output.locationPrivacyString.onNext(locationURL)
                } else {
                    print(" 위치정보처리방침 url 못가져옴 ")
                    let errorURL = "https://lumpy-berry-693.notion.site/061dabcb67a149fbb921f8a600509ac7?pvs=4"
                    output.locationPrivacyString.onNext(errorURL)
                }
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

extension LocationPrivacyViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    public struct Output {
        var locationPrivacyString: PublishSubject<String>
    }
}

