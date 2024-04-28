//
//  BCTimer.swift
//  Core
//
//  Created by gnksbm on 3/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

public final class BCTimer {
    public var distanceFromStart = BehaviorRelay<Int>(value: 0)
    
    private var disposeBag = DisposeBag()
    public init() { }
    
    public func start(interval: RxTimeInterval = .seconds(1)) {
        Observable
            .interval(
                interval,
                scheduler: ConcurrentDispatchQueueScheduler(qos: .utility)
            )
            .bind(to: distanceFromStart)
            .disposed(by: disposeBag)
    }
    
    public func stop() {
        disposeBag = .init()
    }
}
