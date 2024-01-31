//
//  FavoritesUseCase.swift
//  Domain
//
//  Created by gnksbm on 1/26/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol FavoritesUseCase {
    var favorites: BehaviorSubject<FavoritesResponse> { get }
    var favoritesSections: PublishSubject<[FavoritesSection]> { get }
    
    func fetchFavoritesArrivals()
}
