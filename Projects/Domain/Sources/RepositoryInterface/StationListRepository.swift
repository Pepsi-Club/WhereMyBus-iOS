//
//  StationListRepository.swift
//  Domain
//
//  Created by 유하은 on 2024/02/27.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol StationListRepository {
    var searchResponse: BehaviorSubject<[BusStopInfoResponse]> { get }
    func jsontoSearchData()
    func saveRecentSearch(_ searchText: String)
}
