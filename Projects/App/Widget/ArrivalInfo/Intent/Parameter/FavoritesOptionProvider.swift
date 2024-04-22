//
//  FavoritesOptionProvider.swift
//  AppUITests
//
//  Created by gnksbm on 4/13/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import AppIntents

import CoreDataService
import Domain

import RxSwift

struct FavoritesOptionProvider: DynamicOptionsProvider {
    private let coreDataService = DefaultCoreDataService()
    
    private let disposeBag = DisposeBag()
    
    func defaultResult() async -> String? {
        nil
    }
    
    func results() async throws -> [String] {
        await withCheckedContinuation { continuation in
            coreDataService.storeStatus
                .subscribe(
                    onNext: { status in
                        if status == .loaded {
                            continuation.resume()
                        }
                    }
                )
                .disposed(by: disposeBag)
        }
        return try coreDataService.fetch(
            type: FavoritesBusResponse.self
        )
        .map { "\($0.busStopName), \($0.busName)" }
    }
}
