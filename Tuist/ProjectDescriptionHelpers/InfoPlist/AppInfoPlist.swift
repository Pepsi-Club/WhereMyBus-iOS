//
//  AppInfoPlist.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 4/11/25.
//

public struct AppInfoPlist: InfoPlistBuildable {
    let displayName: String
    let marketingVersion: String
    let buildVersion: String
    
    public var dictionary: [String : Plist.Value] {
        [
            "CFBundleDisplayName": .string(displayName),
            "CFBundleShortVersionString": .string(marketingVersion),
            "CFBundleVersion": .string(.buildVersion),
            "CFBundleExecutable": "$(EXECUTABLE_NAME)",
            "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
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
            "CFBundlePackageType": "APPL",
            "UIRequiresFullScreen": true,
            "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
            "FirebaseAppDelegateProxyEnabled": false,
            "ITSAppUsesNonExemptEncryption": "NO",
            "NSAppTransportSecurity": [
                "NSExceptionDomains": [
                    "ws.bus.go.kr": [
                        "NSIncludesSubdomains": true,
                        "NSExceptionAllowsInsecureHTTPLoads": true,
                    ]
                ]
            ],
            "UIBackgroundModes": [
                "fetch",
                "processing",
                "remote-notification"
            ],
            "BGTaskSchedulerPermittedIdentifiers" : [.string(.bundleID)],
            "NSLocationWhenInUseUsageDescription" : "주변 정류장을 찾기 위해 권한이 필요합니다.",
            "NSLocationAlwaysAndWhenInUseUsageDescription" : "주변 정류장을 찾기 위해 권한이 필요합니다."
        ]
    }
    
    public init(displayName: String, marketingVersion: String, buildVersion: String) {
        self.displayName = displayName
        self.marketingVersion = marketingVersion
        self.buildVersion = buildVersion
    }
}
