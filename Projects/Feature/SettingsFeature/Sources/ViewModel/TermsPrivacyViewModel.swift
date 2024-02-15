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

public final class TermsPrivacyViewModel {
    private let coordinator: SettingsCoordinator
    private let disposeBag = DisposeBag()
    
    public init(coordinator: SettingsCoordinator) {
        self.coordinator = coordinator
    }
    
    deinit {
        print("viewmodel deinit?")
    }
    
    public func transform() -> Output {
        let output = Output()
        
        return output
    }
}

extension TermsPrivacyViewModel {
    public struct Input {
        
    }
    
    public struct Output {
        let urlString = "아무튼 스트링"
    }
}
