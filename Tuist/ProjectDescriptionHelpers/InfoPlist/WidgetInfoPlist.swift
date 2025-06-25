//
//  WidgetInfoPlist.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 4/11/25.
//

public struct WidgetInfoPlist: InfoPlistBuildable {
    let displayName: String
    let marketingVersion: String
    
    public var dictionary: [String : Plist.Value] {
        [
            "CFBundleDisplayName": .string(displayName),
            "CFBundleShortVersionString": .string(marketingVersion),
            "CFBundleVersion": .string("1"),
            "DATA_GO_KR_API_KEY": "$(DATA_GO_KR_API_KEY)",
            "CFBundlePackageType": "$(PRODUCT_BUNDLE_PACKAGE_TYPE)",
            "NSExtension": [
                "NSExtensionPointIdentifier": "com.apple.widgetkit-extension",
            ],
            "NSAppTransportSecurity": [
                "NSExceptionDomains": [
                    "ws.bus.go.kr": [
                        "NSIncludesSubdomains": true,
                        "NSExceptionAllowsInsecureHTTPLoads": true,
                    ]
                ]
            ],
        ]
    }
    
    public init(displayName: String, marketingVersion: String) {
        self.displayName = displayName
        self.marketingVersion = marketingVersion
    }
}
