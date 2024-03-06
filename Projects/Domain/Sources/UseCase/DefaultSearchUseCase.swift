//
//  DefaultSearchUseCase.swift
//  Domain
//
//  Created by 유하은 on 2024/03/07.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

public final class DefaultSearchUseCase: SearchUseCase {

    public var busStopInfoResponse: BusStopInfoResponse
    
    private var busStopInfoList: [BusStopInfoResponse] = []

    private let disposeBag = DisposeBag()
    
    public init(
        busStopInfoResponse: BusStopInfoResponse,
        busStopInfoList: [BusStopInfoResponse]
    ) {
        self.busStopInfoResponse = busStopInfoResponse
        self.busStopInfoList = busStopInfoList
    }
    
    public func getRecentSearches() -> [String] {
          return UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
      }
    
    // MARK: Json값 모델에 저장 <질문> 앱 구동할때마다 이게 만들어지면 비효율적일거같은데
    // 이게 맞을까? 앱 맨 첫단에서 하는게 맞을 거 같다
    public func jsontoSearchData() -> [BusStopInfoResponse] {
            var busStopInfoList: [BusStopInfoResponse] = []
            
            if let path = Bundle.main.path(
                forResource: "Dummy_stationList",
                ofType: "json"
            ) {
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
                                
                                busStopInfoList.append(busStopInfo)
                            }
                        }
                    }
                } catch {
                    // JSON 파싱 오류 처리
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
            
            return busStopInfoList
        }
    
    // 필요 유무를 모르겠음
    public func loadBusStopInfoList() {
        busStopInfoList = jsontoSearchData()
    }
    
    public func searchBusStop(with searchText: String)
    ->
    [BusStopInfoResponse] {
        let filteredStops = busStopInfoList.filter { request in
            return request.busStopName.lowercased().contains(
                searchText.lowercased()
            )
        }

        return filteredStops
    }
}
