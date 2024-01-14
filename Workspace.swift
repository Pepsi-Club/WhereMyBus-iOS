//
//  Workspace.swift
//  Clone_AppStoreManifests
//
//  Created by gnksbm on 2023/11/18.
//

import ProjectDescription
import EnvironmentPlugin

let workspace = Workspace(
    name: .appName,
    projects: ["Projects/**"],
    additionalFiles: [
        "README.md",
        ".swiftlint.yml",
    ]
)
