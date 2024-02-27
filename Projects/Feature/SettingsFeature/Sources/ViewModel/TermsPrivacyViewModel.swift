//
//  TermsPrivacyViewModel.swift
//  SettingsFeature
//
//  Created by Jisoo HAM on 2/15/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain
import FeatureDependency

import RxSwift

public final class TermsPrivacyViewModel: ViewModel {
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
            termsOfPrivacyString: .init() 
        )
        
        input.viewWillAppearEvent
            .subscribe(onNext: {
                guard var termsPrivacyURL = Bundle.main.object(forInfoDictionaryKey: "TERMS_OF_PRIVACY_URL") as? String else { return }
                
                termsPrivacyURL = "https://" + termsPrivacyURL
                output.termsOfPrivacyString.onNext(termsPrivacyURL)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

extension TermsPrivacyViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    public struct Output {
        var termsOfPrivacyString: PublishSubject<String>
    }
}
