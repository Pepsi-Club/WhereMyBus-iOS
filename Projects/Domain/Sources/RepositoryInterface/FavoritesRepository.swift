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
    var favorites: BehaviorSubject<[FavoritesBusResponse]> { get }
    
    func fetchFavorites() -> Observable<[FavoritesBusResponse]>
    func addFavorites(favorites: FavoritesBusResponse) throws
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
