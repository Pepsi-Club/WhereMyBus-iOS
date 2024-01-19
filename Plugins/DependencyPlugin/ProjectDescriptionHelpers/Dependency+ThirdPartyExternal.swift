//
//  Dependency+ThirdPartyExternal.swift
//  DependencyPlugin
//
//  Created by gnksbm on 2023/12/27.
//

import ProjectDescription

public extension Array<TargetDependency> {
    enum ThirdPartyExternal: CaseIterable {
        case rxSwift, rxCocoa, kakaoMap
        
        public var name: String {
            switch self {
            case .rxSwift:
                return "RxSwift"
            case .rxCocoa:
                return "RxCocoa"
            case .kakaoMap:
                return "KakaoMapsSDK_SPM"
            }
        }
    }
}
