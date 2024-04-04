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
    public let searchedStationList = PublishSubject<[BusStopRegion]>()
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
        guard !term.isEmpty 
        else {
            searchedStationList.onNext([])
            return
        }
        do {
            let filteredTerm = term.replacingOccurrences(
                of: " ",
                with: ""
            )
            let filteredList = try stationListRepository.busStopRegions
                .value()
                .flatMap { region in
                    switch region {
                    case .seoul(let responses):
                        return responses
                    }
                }
                .filter { response in
                    let busStopIdPrefix = response.busStopId
                        .prefix(filteredTerm.count)
                    
                    return filteredTerm.count > 2 &&
                    busStopIdPrefix == filteredTerm ||
                    response.busStopName.contains(filteredTerm)
                }
                .sorted {
                    $0.busStopName.hasPrefix(filteredTerm) &&
                    !$1.busStopName.hasPrefix(filteredTerm) ||
                    $0.busStopId < $1.busStopId
                }
            searchedStationList.onNext([.seoul(responses: filteredList)])
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
        stationListRepository.busStopRegions
            .map { regions in
                regions.flatMap { region in
                    var busStopList = [BusStopInfoResponse]()
                    switch region {
                    case .seoul(let responses):
                        busStopList = responses
                    }
                    return busStopList.filter { $0.busStopId == busStopId }
                }
            }
    }

    public func updateNearByStop() {
        locationService.locationStatus
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, status in
                    var response: BusStopInfoResponse
                    var distanceStr: String
                    let requestMessage = "확인하려면 위치사용을 허용해주세요"
                    let errorMessage = "오류가 발생했습니다 관리자에게 문의해주세요"
                    switch status {
                    case .authorized(let location), 
                            .alwaysAllowed(let location):
                        (response, distanceStr) = useCase.stationListRepository
                            .getNearByStopInfo(startPointLocation: location)
                    case .notDetermined, .denied:
                        response = .init(
                            busStopName: requestMessage,
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
