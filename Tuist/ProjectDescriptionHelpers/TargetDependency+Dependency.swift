//
//  TargetDependency+Dependency.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 3/30/25.
//

import ProjectDescription

public extension TargetDependency {
    struct SPM { }
    struct XCFramework { }
    
    private static func localXCFramework(name: String) -> TargetDependency {
        .xcframework(path: .relativeToFrameworks(name))
    }
}

public extension TargetDependency.SPM {
    static let RxSwift: TargetDependency = .external(name: "RxSwift")
    static let RxCocoa: TargetDependency = .external(name: "RxCocoa")
    static let Lottie: TargetDependency = .external(name: "Lottie")
    static let FirebaseAnalytics: TargetDependency = .external(name: "FirebaseAnalytics")
    static let FirebaseMessaging: TargetDependency = .external(name: "FirebaseMessaging")
}

public extension TargetDependency.XCFramework {
    static let NMapsGeometry: TargetDependency = .localXCFramework(name: "NMapsGeometry")
    static let NMapsMap: TargetDependency = .localXCFramework(name: "NMapsMap")
}

