//
//  UIKitInfoPlist.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 4/11/25.
//

import Foundation

public struct UIKitInfoPlist: InfoPlistBuildable {
    public var dictionary: [String : ProjectDescription.Plist.Value] {
        [
            "UILaunchStoryboardName": "LaunchScreen.storyboard",
            "UIApplicationSceneManifest": [
                "UIApplicationSupportsMultipleScenes": false,
                "UISceneConfigurations": [
                    "UIWindowSceneSessionRoleApplication": [
                        [
                            "UISceneConfigurationName": "Default Configuration",
                            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                        ],
                    ]
                ]
            ],
            "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"]
        ]
    }
    
    public init() { }
}
