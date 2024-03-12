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
    var busStopInfoList: [BusStopInfoResponse] { get }
    // 은닉화?
    var searchResponse: BehaviorSubject<[BusStopInfoResponse]> { get }
    func jsontoSearchData()
    //얘를 useCase로 보내던지 useCase에 있는 getRecentSearch를 레포로 보내던지
    func saveRecentSearch(_ searchText: String)
}
