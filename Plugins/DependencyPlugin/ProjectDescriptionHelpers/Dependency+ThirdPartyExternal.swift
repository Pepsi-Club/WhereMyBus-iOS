//
//  Dependency+ThirdPartyExternal.swift
//  DependencyPlugin
//
//  Created by gnksbm on 2023/12/27.
//

import ProjectDescription

public extension Array<TargetDependency> {
    enum ThirdPartyExternal: CaseIterable {
        case rxDataSources, kakaoMap, swiftyXMLParser
        
        public var name: String {
            switch self {
            case .rxDataSources:
                return "RxDataSources"
            case .kakaoMap:
                return "KakaoMapsSDK_SPM"
            case .swiftyXMLParser:
                return "SwiftyXMLParser"
            }
        }
    }
}
