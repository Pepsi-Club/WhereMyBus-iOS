//
//  Project+Templates.swift
//  Config
//
//  Created by gnksbm on 2023/11/19.
//

import ProjectDescription
import EnvironmentPlugin
import DependencyPlugin

import ProjectDescription
import EnvironmentPlugin
import DependencyPlugin

extension Project {
    // MARK: Refact
    public static func makeProject(
        name: String,
        moduleType: ModuleType,
        entitlements: Path? = nil,
        isTestable: Bool = false,
        hasResource: Bool = false,
        additionalPath: String = "",
        dependencies: [TargetDependency]
    ) -> Self {
        var schemes = [Scheme]()
        var targets = [Target]()
        var targetModule: Target
        switch moduleType {
        case .app:
            targetModule = appTarget(
                name: name,
                entitlements: entitlements,
                dependencies: dependencies
            )
        case .dynamicFramework, .staticFramework:
            targetModule = frameworkTarget(
                name: name,
                entitlements: entitlements,
                hasResource: hasResource, 
                productType: moduleType.product,
                additionalPath: additionalPath, 
                dependencies: dependencies
            )
        case .presentation:
            targetModule = frameworkTarget(
                name: name,
                entitlements: entitlements,
                hasResource: hasResource,
                productType: moduleType.product,
                isPresentation: true,
                additionalPath: additionalPath,
                dependencies: dependencies
            )
//            let demoTarget = demoAppTarget(
//                name: name,
//                dependencies: [.target(targetModule)]
//            )
//            targets.append(demoTarget)
        }
        targets.append(targetModule)
        schemes.append(.moduleScheme(name: name))
//        if isTestable {
//            let test = unitTestTarget(
//                name: name,
//                dependencies: [.target(targetModule)]
//            )
//            targets.append(test)
//        }
        return Project(
            name: name,
            organizationName: .organizationName,
            targets: targets,
            schemes: schemes
        )
    }
    
    private static func appTarget(
        name: String,
        entitlements: Path?,
        dependencies: [TargetDependency]
    ) -> Target {
        Target(
            name: name,
            platform: .iOS,
            product: .app,
            bundleId: .bundleID,
            deploymentTarget: .deploymentTarget,
            infoPlist: .appInfoPlist,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: entitlements,
            scripts: [.swiftLint],
            dependencies: dependencies,
            settings: .appDebug
        )
    }

    private static func demoAppTarget(
        name: String,
        entitlements: Path? = nil,
        dependencies: [TargetDependency]
    ) -> Target {
        Target(
            name: "\(name)DemoApp",
            platform: .iOS,
            product: .app,
            bundleId: .bundleID + ".\(name)DemoApp",
            deploymentTarget: .deploymentTarget,
            infoPlist: .appInfoPlist,
            sources: [
                "Demo/**",
                "Sources/**"
            ],
            entitlements: entitlements,
            scripts: [.featureSwiftLint],
            dependencies: dependencies
        )
    }

    private static func frameworkTarget(
        name: String,
        entitlements: Path?,
        hasResource: Bool,
        productType: Product,
        isPresentation: Bool = false,
        additionalPath: String,
        dependencies: [TargetDependency]
    ) -> Target {
        let scripts: [TargetScript] = isPresentation ?
        [.featureSwiftLint] :
            additionalPath.isEmpty ? [.swiftLint] :
            [.featureSwiftLint]
        return Target(
            name: name,
            platform: .iOS,
            product: .framework,
            bundleId: .bundleID + ".\(name)",
            deploymentTarget: .deploymentTarget,
            infoPlist: .frameworkInfoPlist,
            sources: ["Sources/**"],
            resources: hasResource ? ["Resources/**"] : nil,
            entitlements: entitlements,
            scripts: scripts,
            dependencies: dependencies
        )
    }
    
    private static func unitTestTarget(
        name: String,
        isFeature: Bool = false,
        dependencies: [TargetDependency]
    ) -> Target {
        Target(
            name: "\(name)Tests",
            platform: .iOS,
            product: .unitTests,
            bundleId: .bundleID + ".\(name)Test",
            deploymentTarget: .deploymentTarget,
            infoPlist: .frameworkInfoPlist,
            sources: ["Tests/**"],
            scripts: isFeature ? [.featureSwiftLint] : [.swiftLint],
            dependencies: dependencies,
            settings: .test
        )
    }
}
