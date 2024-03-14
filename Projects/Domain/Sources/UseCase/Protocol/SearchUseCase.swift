//
//  SearchUseCase.swift
//  Domain
//
//  Created by 유하은 on 2024/03/07.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol SearchUseCase {
    var searchedStationList: PublishSubject<[BusStopInfoResponse]> { get }
    var recentSearchResult: BehaviorSubject<[BusStopInfoResponse]> { get }
    
    func search(term: String)
    func getStationList()
    func getRecentSearchList()
}
