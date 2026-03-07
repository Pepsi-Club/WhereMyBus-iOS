//
//  TargetBuildable.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 3/31/25.
//

public protocol TargetBuildable {
    var name: String { get }
    var product: Product { get }
    var productName: String? { get }
    var bundleId: String { get }
    var infoPlist: InfoPlist?  { get }
    var sources: SourceFilesList?  { get }
    var resources: ResourceFileElements?  { get }
    var copyFiles: [CopyFilesAction]? { get }
    var headers: Headers? { get }
    var entitlements: Entitlements? { get }
    var scripts: [TargetScript] { get }
    var dependencies: [TargetDependency] { get }
    var settings: Settings? { get }
    var coreDataModels: [CoreDataModel] { get }
    var environmentVariables: [String : EnvironmentVariable] { get }
    var launchArguments: [LaunchArgument] { get }
    var additionalFiles: [FileElement] { get }
    var buildRules: [BuildRule] { get }
    var mergedBinaryType: MergedBinaryType { get }
    var mergeable: Bool { get }
    var onDemandResourcesTags: OnDemandResourcesTags? { get }
}

public extension TargetBuildable {
    var destinations: Destinations { .iPhone }
    var productName: String? { nil }
    var deploymentTargets: DeploymentTargets? { .iOS(.targetVersion) }
    var infoPlist: InfoPlist? { .default }
    var sources: SourceFilesList? { nil }
    var resources: ResourceFileElements? { nil }
    var copyFiles: [CopyFilesAction]? { nil }
    var headers: Headers? { nil }
    var entitlements: Entitlements? { nil }
    var scripts: [TargetScript] { [] }
    var dependencies: [TargetDependency] { [] }
    var settings: Settings? { nil }
    var coreDataModels: [CoreDataModel] { [] }
    var environmentVariables: [String : EnvironmentVariable] { [:] }
    var launchArguments: [LaunchArgument] { [] }
    var additionalFiles: [FileElement] { [] }
    var buildRules: [BuildRule] { [] }
    var mergedBinaryType: MergedBinaryType { .disabled }
    var mergeable: Bool { false }
    var onDemandResourcesTags: OnDemandResourcesTags? { nil }
    
    func buildTarget() -> Target {
        .target(
            name: name,
            destinations: destinations,
            product: product,
            productName: productName,
            bundleId: bundleId,
            deploymentTargets: deploymentTargets,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            copyFiles: copyFiles,
            headers: headers,
            entitlements: entitlements,
            scripts: scripts,
            dependencies: dependencies,
            settings: settings,
            coreDataModels: coreDataModels,
            environmentVariables: environmentVariables,
            launchArguments: launchArguments,
            additionalFiles: additionalFiles,
            buildRules: buildRules,
            mergedBinaryType: mergedBinaryType,
            mergeable: mergeable,
            onDemandResourcesTags: onDemandResourcesTags
        )
    }
}
