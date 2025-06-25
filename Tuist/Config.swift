//
//  Config.swift
//  Clone_AppStoreManifests
//
//  Created by gnksbm on 2023/11/19.
//

import ProjectDescription

let config = Config(
    compatibleXcodeVersions: .list([
        .upToNextMajor(.init(15, 0, 0)),
        .upToNextMajor(.init(16, 0, 0))
    ]),
    swiftVersion: .init(5, 0, 0),
    plugins: [
        .local(path: .relativeToRoot("Plugins/EnvironmentPlugin"))
    ]
)
