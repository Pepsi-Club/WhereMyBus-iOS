//
//  SampleAppScheme.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/6/25.
//

public struct SampleAppScheme: SchemeBuildable {
    public let name: String
    
    public let shared: Bool = true
    public var buildAction: BuildAction? {
        .buildAction(
            targets: ["\(name)"]
        )
    }
    
    public init(name: String) {
        self.name = name + "SampleApp"
    }
}
