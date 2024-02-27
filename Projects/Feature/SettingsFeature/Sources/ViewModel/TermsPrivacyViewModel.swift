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
                // MARK: - config + info plist에 있는 값을 가져오는 방식에서 문제인건지 계속 else로 빠짐
                if let termsURL = Bundle.main.object(forInfoDictionaryKey: "TERMS_OF_PRIVACY_URL") as? String {
                    output.termsOfPrivacyString.onNext(termsURL)
                } else {
                    let errorURL = "https://lumpy-berry-693.notion.site/061dabcb67a149fbb921f8a600509ac7?pvs=4"
                    output.termsOfPrivacyString.onNext(errorURL)
                }
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
