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
            requirement: .branch($0.branch)
        )
    }, productTypes: [
        "RxCocoa": .framework,
        "RxCocoaRuntime": .framework,
        "RxDataSources": .framework,
        "Differentiator": .framework,
    ]
)

let dependencies = Dependencies(
    carthage: carthage,
    swiftPackageManager: spm,
    platforms: [.iOS]
)
