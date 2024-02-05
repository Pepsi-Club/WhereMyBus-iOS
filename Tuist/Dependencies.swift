//
//  Dependencies.swift
//  Config
//
//  Created by gnksbm on 2023/11/19.
//

import ProjectDescription
import DependencyPlugin

let carthage = CarthageDependencies(
    [
    ]
)

let spm = SwiftPackageManagerDependencies(
    .ThirdPartyRemote.SPM.allCases.map {
        Package.remote(
            url: $0.url,
            requirement: .upToNextMajor(from: $0.upToNextMajor)
        )
    }, productTypes: [
        "RxCocoa": .framework,
        "RxCocoaRuntime": .framework,
        "RxDataSources": .framework,
        "Differentiator": .framework,
		"KakaoMapsSDK-SPM": .framework,
		"KakaoMapsSDKBundle": .bundle,
    ]
)

let dependencies = Dependencies(
    carthage: carthage,
    swiftPackageManager: spm,
    platforms: [.iOS]
)
