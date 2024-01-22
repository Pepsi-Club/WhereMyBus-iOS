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
            schemes.append(.moduleScheme(name: name))
        case .dynamicFramework, .staticFramework:
            targetModule = frameworkTarget(
                name: name,
                entitlements: entitlements,
                hasResource: hasResource, 
                productType: moduleType.product,
                dependencies: dependencies
            )
        case .feature:
            targetModule = frameworkTarget(
                name: name,
                entitlements: entitlements,
                hasResource: hasResource,
                productType: moduleType.product,
                isPresentation: true,
                dependencies: dependencies
            )
            let demoTarget = demoAppTarget(
                name: name,
                dependencies: [.target(targetModule)]
            )
            targets.append(demoTarget)
            schemes.append(.moduleScheme(name: demoTarget.name))
        }
        targets.append(targetModule)
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
            name: "\(name)Demo",
            platform: .iOS,
            product: .app,
            bundleId: .bundleID + ".\(name)Demo",
            deploymentTarget: .deploymentTarget,
            infoPlist: .appInfoPlist,
            sources: [
                "Demo/**",
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
        dependencies: [TargetDependency]
    ) -> Target {
        let scripts: [TargetScript] = isPresentation ?
        [.featureSwiftLint] : [.swiftLint]
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
