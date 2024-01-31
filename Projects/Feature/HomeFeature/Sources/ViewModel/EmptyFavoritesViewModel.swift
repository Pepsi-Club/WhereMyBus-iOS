//
//  EmptyFavoritesViewModel.swift
//  HomeFeature
//
//  Created by gnksbm on 1/26/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift

public final class EmptyFavoritesViewModel: ViewModel {
    private let coordinator: HomeCoordinator
    @Injected(FavoritesUseCase.self) var useCase: FavoritesUseCase
    
    private let disposeBag = DisposeBag()
    
    public init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    public func transform(input: Input) -> Output {
        let output = Output()
        
        input.searchBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.coordinator.startSearchFlow()
                }
            )
            .disposed(by: disposeBag)
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    guard let favorites = try? viewModel.useCase.favorites
                        .value()
                    else { return }
                    viewModel.coordinator.updateFavoritesState(
                        isEmpty: favorites.busStops.isEmpty
                    )
                }
            )
            .disposed(by: disposeBag)
        
        useCase.favorites
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, favorites in
                    viewModel.coordinator.updateFavoritesState(
                        isEmpty: favorites.busStops.isEmpty
                    )
                }
            )
            .disposed(by: disposeBag)
        
        return output
    }
}

extension EmptyFavoritesViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
        let searchBtnTapEvent: Observable<Void>
    }
    
    public struct Output {
    }
}
