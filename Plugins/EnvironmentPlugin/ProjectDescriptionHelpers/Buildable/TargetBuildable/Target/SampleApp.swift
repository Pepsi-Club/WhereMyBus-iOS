//
//  SampleApp.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/6/25.
//

public struct SampleApp: BundleIDSuffixTarget {
    public let name: String
    public let dependencies: [TargetDependency]
    
    public let product: Product = .app
    public let bundleId: String = .bundleID + ".Demo"
    public let sources: SourceFilesList?  = ["Demo/**"]
    public let settings: Settings? = .appDebug

    public var infoPlist: InfoPlist?
    
    public init(
        name: String,
        @TargetComponentBuilder dependencies builder: () -> TargetComponentBuilder
    ) {
        let builder = builder()
        self.name = name + "SampleApp"
        self.dependencies = builder.buildTargetDependency()
        self.infoPlist = builder.buildInfoPlist()
    }
}
