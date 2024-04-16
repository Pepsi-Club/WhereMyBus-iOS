//
//  MockFavoritesRepository.swift
//  FeatureDependency
//
//  Created by gnksbm on 3/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

import RxSwift

#if DEBUG
public final class MockFavoritesRepository: FavoritesRepository {
    public var favorites = BehaviorSubject<[FavoritesBusResponse]>(
        value: []
    )
    
    public init() {
        
    }
    
    public func addFavorites(favorites: FavoritesBusResponse) throws {
        
    }
    public func removeFavorites(favorites: FavoritesBusResponse) throws {
        
    }
}
#endif
