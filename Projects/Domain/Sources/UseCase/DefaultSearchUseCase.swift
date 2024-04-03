//
//  DefaultSearchUseCase.swift
//  Domain
//
//  Created by 유하은 on 2024/03/07.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import CoreLocation
import Foundation

import RxSwift
import RxCocoa

public final class DefaultSearchUseCase: SearchUseCase {
    private let stationListRepository: StationListRepository
    private let locationService: LocationService
    
    public var locationStatus = BehaviorSubject<LocationStatus>(
        value: .notDetermined
    )
    public let nearByStopInfo = PublishSubject<(BusStopInfoResponse, String)>()
    public let searchedStationList = PublishSubject<[BusStopInfoResponse]>()
    public var recentSearchResult = BehaviorSubject<[BusStopInfoResponse]>(
        value: []
    )
    private let disposeBag = DisposeBag()
    
    public init(
        stationListRepository: StationListRepository,
        locationService: LocationService
    ) {
        self.stationListRepository = stationListRepository
        self.locationService = locationService
        bindLocationStatus()
        bindRecentSearchList()
    }
    
    public func search(term: String) {
        do {
            let filteredList = try stationListRepository.stationList.value()
                .filter { response in
                    (
                        term.count > 3 &&
                        response.busStopId.prefix(term.count) == term
                    ) ||
                    response.busStopName.contains(term)
                }
            searchedStationList.onNext(filteredList)
        } catch {
            searchedStationList.onError(error)
        }
    }
    
    public func removeRecentSearch() {
        stationListRepository.removeRecentSearch()
    }
    
    public func saveRecentSearch(response: BusStopInfoResponse) {
        stationListRepository.saveRecentSearch(response)
    }
    
    public func requestAuthorize() {
        locationService.authorize()
    }
    
    public func getBusStopInfo(
        for busStopId: String
    ) -> Observable<[BusStopInfoResponse]> {
        stationListRepository.stationList
            .map { stationList in
                stationList.filter { $0.busStopId == busStopId }
        }
    }
    
    public func updateNearByStop() {
        locationService.locationStatus
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, status in
                    var response: BusStopInfoResponse
                    var distanceStr: String
                    let requestMessage1 = "주변 정류장을 확인하려면\n"
                    let requestMessage2 = "위치 사용을 허용해주세요"
                    let errorMessage = "오류가 발생했습니다 관리자에게 문의해주세요"
                    switch status {
                    case .authorized(let location), 
                            .alwaysAllowed(let location):
                        (response, distanceStr) = useCase.stationListRepository
                            .getNearByStopInfo(startPointLocation: location)
                    case .notDetermined, .denied:
                        response = .init(
                            busStopName: requestMessage1 + requestMessage2,
                            busStopId: "",
                            direction: "",
                            longitude: "126.979620",
                            latitude: "37.570028"
                        )
                        distanceStr = ""
                    case .unknown:
                        response = .init(
                            busStopName: errorMessage,
                            busStopId: "",
                            direction: "",
                            longitude: "126.979620",
                            latitude: "37.570028"
                        )
                        distanceStr = ""
                    }
                    useCase.nearByStopInfo.onNext((response, distanceStr))
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func bindLocationStatus() {
        locationService.locationStatus
            .bind(to: locationStatus)
            .disposed(by: disposeBag)
    }
    
    private func bindRecentSearchList() {
        stationListRepository.recentlySearchedStation
            .bind(to: recentSearchResult)
            .disposed(by: disposeBag)
    }
}
