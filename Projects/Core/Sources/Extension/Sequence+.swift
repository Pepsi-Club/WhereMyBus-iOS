//
//  Sequence+.swift
//  Core
//
//  Created by gnksbm on 4/14/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public extension Sequence {
    /**
     키패스로 배열의 요소를 비교해 중복되지 않는 요소를 반환하는 함수
     
     - Parameters:
       - target: 비교할 타겟 배열
       - sourceKeyPath: 원본 배열의 요소를 식별하는 키패스
       - targetKeyPath: 타겟 배열의 요소를 식별하는 키패스
     
     - Returns: (sourceMissing: 타겟 배열에만 존재하는 요소들,
        targetMissing: 원본 배열에만 존재하는 요소들)
     */
    func compareDiff<Target, ComparableKeyPath: Hashable>(
        sourceKeyPath: KeyPath<Element, ComparableKeyPath>,
        target: [Target],
        targetKeyPath: KeyPath<Target, ComparableKeyPath>
    ) -> (sourceMissing: [Target], targetMissing: [Element]) {
        let sourceDic = Dictionary(
            uniqueKeysWithValues: map {
                ($0[keyPath: sourceKeyPath], $0)
            }
        )
        let targetDic = Dictionary(
            uniqueKeysWithValues: target.map {
                ($0[keyPath: targetKeyPath], $0)
            }
        )
        
        let sourceMissing = target.filter { targetElement in
            sourceDic[targetElement[keyPath: targetKeyPath]] == nil
        }
        let targetMissing = filter { sourceElement in
            targetDic[sourceElement[keyPath: sourceKeyPath]] == nil
        }
        
        return (sourceMissing, targetMissing)
    }
}
