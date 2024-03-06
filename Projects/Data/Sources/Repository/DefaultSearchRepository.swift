//
//  DefaultSearchRepository.swift
//  Data
//
//  Created by 유하은 on 2024/02/27.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

import Domain

public final class DefaultSearchRepository: SearchRepository {
    
    public var searchResponse: BehaviorSubject<[Domain.BusStopInfoResponse]>
    
    private let recentSearchesSubject = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    
    private let maxRecentSearchCount = 5
    
    public init(searchResponse: BehaviorSubject<[Domain.BusStopInfoResponse]>) {
        self.searchResponse = searchResponse
    }
    

    // UserDefaults에 최대 5개 항목만 저장함. 근데 BusStopInfoResponse 형태로 받아야 함. 
    func saveRecentSearch(_ searchText: String) {
        var currentSearches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
        
        // 최대 갯수에 도달하면 가장 오래된 항목을 제거
        if currentSearches.count >= maxRecentSearchCount {
            currentSearches.removeFirst()
        }
        
        // 새로운 검색어를 추가
        currentSearches.append(searchText)
        
        UserDefaults.standard.set(currentSearches, forKey: "recentSearches")
        
        recentSearchesSubject.onNext(searchText)
    }
    

}

