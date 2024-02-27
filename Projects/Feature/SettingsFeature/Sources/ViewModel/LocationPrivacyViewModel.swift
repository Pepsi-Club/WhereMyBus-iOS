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
                guard var locationURL = Bundle.main.object(forInfoDictionaryKey: "LOCATION_PRIVACY_URL") as? String else { return }
                
                locationURL = "https://" + locationURL
                output.locationPrivacyString.onNext(locationURL)
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

