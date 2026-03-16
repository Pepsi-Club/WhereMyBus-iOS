//
//  FavoritesRepository.swift
//  Domain
//
//  Created by gnksbm on 1/30/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol FavoritesRepository {
    @available(*, deprecated, message: "이 변수는 제거될 예정입니다.")
    var favorites: BehaviorSubject<[FavoritesBusResponse]> { get }
    
    @available(*, deprecated, message: "이 메서드는 제거될 예정입니다.")
    func fetchFavorites() -> Observable<[FavoritesBusResponse]>
    @available(*, deprecated, message: "이 메서드는 제거될 예정입니다.")
    func addFavorites(favorites: FavoritesBusResponse) throws
    @available(*, deprecated, message: "이 메서드는 제거될 예정입니다.")
    func removeFavorites(favorites: FavoritesBusResponse) throws
}

public protocol AsyncFavoritesRepository {
    var favoritesStream: AsyncStream<[FavoritesBusResponse]> { get }
    
    func fetchFavorites() async throws -> [FavoritesBusResponse]
    func addFavorites(favorite: FavoritesBusResponse) async throws
    func removeFavorites(favorite: FavoritesBusResponse) async throws
}

extension AsyncFavoritesRepository {
    func fetchFavorites() -> Observable<[FavoritesBusResponse]> {
        Single.create {
            try await fetchFavorites()
        }
        .asObservable()
    }
}
