//
//  ThirdPartyLibs.swift
//  Environment
//
//  Created by gnksbm on 2023/11/19.
//

import ProjectDescription

public extension Array<Package> {
    struct ThirdPartyRemote {
    }
}

public extension Array<Package>.ThirdPartyRemote {
    enum SPM: CaseIterable {
        case rxDataSources, kakaoMap, swiftyXMLParser
        
        public var url: String {
            switch self {
            case .rxDataSources:
                return "https://github.com/RxSwiftCommunity/RxDataSources"
            case .kakaoMap:
                return "https://github.com/kakao-mapsSDK/KakaoMapsSDK-SPM"
            case .swiftyXMLParser:
                return "https://github.com/yahoojapan/SwiftyXMLParser"
            }
        }
        
        public var upToNextMajor: Version {
            switch self {
            case .rxDataSources:
                return "5.0.2"
            case .kakaoMap:
                return "2.6.3"
            case .swiftyXMLParser:
                return "5.6.0"
            }
        }
    }
}
