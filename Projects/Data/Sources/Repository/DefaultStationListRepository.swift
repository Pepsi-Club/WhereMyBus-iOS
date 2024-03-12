//
//  DefaultStationListRepository.swift
//  Data
//
//  Created by 유하은 on 2024/02/27.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

import Domain

public final class DefaultStationListRepository: StationListRepository {
    public var searchResponse = BehaviorSubject<[BusStopInfoResponse]>( value: [])
    public var busStopInfoList: [BusStopInfoResponse] = []

    private let recentSearchesSubject = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    
    private let maxRecentSearchCount = 5
    
    public func getRecentSearches() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
    }
    
    public init() {
        // MARK: 바꿔야 할 수도 있음
        jsontoSearchData()
    }
    
    // MARK: Json값 모델에 저장 <질문> 뷰 어피어할때마다 이게 이루어지면 비효율적일거같은데, 앱 첫단에서 하면 안될까
    
    public func jsontoSearchData() {
        
        if let path = Bundle.main.path(
            forResource: "Dummy_stationList",
            ofType: "json") {
            do {
                let data = try Data(
                    contentsOf: URL(fileURLWithPath: path),
                    options: .mappedIfSafe
                )
                let jsonResult = try JSONSerialization.jsonObject(
                    with: data,
                    options: .mutableLeaves
                )
                
                if let jsonArray = jsonResult as? [[String: Any]] {
                    for jsonDict in jsonArray {
                        if let busStopId = jsonDict["stop_no"] as? String,
                           let busStopName = jsonDict["stop_nm"] as? String,
                           let direction = jsonDict["nxtStn"] as? String,
                           let longitude = jsonDict["longitude"] as? String,
                           let latitude = jsonDict["latitude"] as? String {
                            let busStopInfo = BusStopInfoResponse(
                                busStopName: busStopName,
                                busStopId: busStopId,
                                direction: direction,
                                longitude: longitude,
                                latitude: latitude
                            )
                            
                            self.busStopInfoList.append(busStopInfo)
                        }
                    }
                }
            } catch {
                // JSON 파싱 오류 처리
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
    }
    
    // UserDefaults에 최대 5개 항목만 저장함. 근데 BusStopInfoResponse 형태로 받아야 함.
    // TODO: 수정사항 클릭한 cell의 정보를 받아와야함 String이 아니라
    public func saveRecentSearch(_ searchText: String) {
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

