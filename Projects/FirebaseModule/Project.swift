//
//  Project.swift
//  AlarmFeatureManifests
//
//  Created by Logan on 3/30/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "FirebaseModule",
    moduleType: .staticFramework,
    dependencies: [
        .FirebaseInterface,
        .SPM.FirebaseAnalytics,
        .SPM.FirebaseMessaging
    ]
)
