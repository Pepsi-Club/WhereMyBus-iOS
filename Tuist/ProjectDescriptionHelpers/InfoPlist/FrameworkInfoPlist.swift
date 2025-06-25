//
//  FrameworkInfoPlist.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 4/11/25.
//

public struct FrameworkInfoPlist: InfoPlistBuildable {
    let marketingVersion: String
    
    public var dictionary: [String : Plist.Value] {
        [
            "CFBundleShortVersionString": .string(marketingVersion),
            "CFBundleVersion": .string("1"),
            "CFBundleDevelopmentRegion": "$(DEVELOPMENT_LANGUAGE)",
            "CFBundleExecutable": "$(EXECUTABLE_NAME)",
            "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
            "CFBundleInfoDictionaryVersion": "6.0",
            "CFBundleName": "$(PRODUCT_NAME)",
            "CFBundlePackageType": "FMWK",
        ]
    }
    
    public init(marketingVersion: String) {
        self.marketingVersion = marketingVersion
    }
}
