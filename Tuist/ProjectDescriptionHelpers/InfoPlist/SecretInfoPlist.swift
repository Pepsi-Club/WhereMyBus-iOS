//
//  SecretInfoPlist.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 4/11/25.
//

public struct SecretInfoPlist: InfoPlistBuildable {
    public var dictionary: [String : Plist.Value] {
        [
            "DATA_GO_KR_API_KEY": "$(DATA_GO_KR_API_KEY)",
            "NMFClientId": "$(NAVERMAP_CLIENT_ID)",
            "TERMS_OF_PRIVACY_URL": "$(TERMS_OF_PRIVACY_URL)",
            "LOCATION_PRIVACY_URL": "$(LOCATION_PRIVACY_URL)",
            "INQUIRY_URL": "$(INQUIRY_URL)",
            "APPSTORE_ID": "$(APPSTORE_ID)",
            "DOMAIN_URL": "$(DOMAIN_URL)",
            "GITHUB_ACCESS_TOKEN": "$(GITHUB_ACCESS_TOKEN)",
        ]
    }
    
    public init() { }
}
