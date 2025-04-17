//
//  App.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 3/31/25.
//

public struct App: TargetBuildable {
    public let name: String
    public let dependencies: [TargetDependency]
    
    public let product: Product = .app
    public let bundleId: String = .bundleID
    public let infoPlist: InfoPlist?
    public let sources: SourceFilesList?  = ["Sources/**"]
    public let resources: ResourceFileElements? = ["Resources/**"]
    public let scripts: [TargetScript]
    public let settings: Settings? = .appDebug

    public var entitlements: Entitlements? {
        .file(path: .relativeToManifest("\(name).entitlements"))
    }
    
    public init(
        name: String,
        @TargetComponentBuilder dependencies builder: () -> TargetComponentBuilder
    ) {
        let builder = builder()
        self.name = name
        self.dependencies = builder.buildTargetDependency()
        self.scripts = builder.buildTargetScript()
        self.infoPlist = builder.buildInfoPlist()
    }
}
