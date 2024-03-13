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
 
    private let disposeBag = DisposeBag()
    
    private let maxRecentSearchCount = 5
    
    public init() {
        // MARK: 바꿔야 할 수도 있음
    }
    
    // MARK: Json값 모델에 저장 <질문> 뷰 어피어할때마다 이게 이루어지면 비효율적일거같은데, 앱 첫단에서 하면 안될까
    
    public func jsontoSearchData() -> Observable<[BusStopInfoResponse]> {
        return Observable.create { observer in
            var busStopInfoList: [BusStopInfoResponse] = []

            if let path = Bundle.main.path(forResource: "Dummy_stationList", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)

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

                                busStopInfoList.append(busStopInfo)
                            }
                        }
                        observer.onNext(busStopInfoList)
                        observer.onCompleted()
                    }
                } catch {
                    // JSON 파싱 오류 처리
                    observer.onError(error)
                }
            }
            // disposeBag해주는것, 구독이 끝나면 종료
            return Disposables.create()
        }
    }
    
    public func saveRecentSearch(_ searchCell: [BusStopInfoResponse]) {
        var currentSearches = UserDefaults.standard.busStopInfoResponses(forKey: "recentSearches")
        
        // 최대 갯수에 도달하면 가장 오래된 항목을 제거
        if currentSearches.count >= maxRecentSearchCount {
            currentSearches.removeFirst()
        }

        currentSearches.append(contentsOf: searchCell)

        UserDefaults.standard.setBusStopInfoResponses(currentSearches, forKey: "recentSearches")
    }
    
    public func getRecentSearch() -> Observable<[BusStopInfoResponse]> {
        return Observable.deferred {
            let recentSearches = UserDefaults.standard.busStopInfoResponses(forKey: "recentSearches")
            return Observable.just(recentSearches)
        }
    }
}

extension UserDefaults {
    func setBusStopInfoResponses(_ value: [BusStopInfoResponse], forKey key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            set(data, forKey: key)
        } catch {
            print("Failed to encode BusStopInfoResponse array: \(error)")
        }
    }

    func busStopInfoResponses(forKey key: String) -> [BusStopInfoResponse] {
        guard let data = data(forKey: key) else { return [] }

        do {
            let decodedData = try JSONDecoder().decode([BusStopInfoResponse].self, from: data)
            return decodedData
        } catch {
            print("Failed to decode BusStopInfoResponse array: \(error)")
            return []
        }
    }
}
