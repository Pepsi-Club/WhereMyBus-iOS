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
                let termsURL = "https://www.youtube.com/watch?v=92f_BNFNHNw"
                output.termsOfPrivacyString.onNext(termsURL)
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
