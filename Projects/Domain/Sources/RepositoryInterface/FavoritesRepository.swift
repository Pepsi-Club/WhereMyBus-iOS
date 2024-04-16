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
    
    func addFavorites(favorites: FavoritesBusResponse) throws
    func removeFavorites(favorites: FavoritesBusResponse) throws
}
