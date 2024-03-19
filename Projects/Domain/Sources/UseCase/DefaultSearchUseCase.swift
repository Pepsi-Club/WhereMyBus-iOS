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

    private let disposeBag = DisposeBag()
    
    public let nearByStop = PublishSubject<BusStopInfoResponse>()
    public let distanceFromNearByStop = PublishSubject<String>()
    public let searchedStationList = PublishSubject<[BusStopInfoResponse]>()
    public var recentSearchResult = BehaviorSubject<[BusStopInfoResponse]>(
        value: []
    )
    
    public init(
        stationListRepository: StationListRepository,
        locationService: LocationService
    ) {
        self.stationListRepository = stationListRepository
        self.locationService = locationService
        bindRecentSearchList()
        bindDistance()
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
    
    public func saveRecentSearch(cell: BusStopInfoResponse) {
        stationListRepository.saveRecentSearch(cell)
    }
    
    public func getBusStopInfo(for busStopId: String
    ) -> Observable<[BusStopInfoResponse]> {
        return stationListRepository.stationList
            .map { stationList in
                return stationList.filter { $0.busStopId == busStopId }
        }
    }
    
    public func updateNearByStop() {
        locationService.currentLocation
            .take(1)
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, location in
                    let result = useCase.stationListRepository
                        .getNearByStopInfo(startPointLocation: location)
                    useCase.nearByStop.onNext(result)
                }
            )
            .disposed(by: disposeBag)
        
        locationService.authState
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, authState in
                    switch authState {
                    case .notDetermined:
                        useCase.locationService.authorize()
                    case .restricted:
                        let desciption = "오류가 발생했습니다. 관리자에게 문의해주세요."
                        let result = BusStopInfoResponse(
                            busStopName: desciption,
                            busStopId: "",
                            direction: "",
                            longitude: "",
                            latitude: ""
                        )
                        useCase.nearByStop.onNext(result)
                    case .denied:
                        let desciption = "주변 정류장을 확인하려면 위치 정보를 동의해주세요."
                        let result = BusStopInfoResponse(
                            busStopName: desciption,
                            busStopId: "",
                            direction: "",
                            longitude: "",
                            latitude: ""
                        )
                        useCase.nearByStop.onNext(result)
                    case .authorizedAlways, .authorizedWhenInUse:
                        useCase.locationService.requestLocationOnce()
                    @unknown default:
                        break
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func bindRecentSearchList() {
        stationListRepository.recentlySearchedStation
            .bind(to: recentSearchResult)
            .disposed(by: disposeBag)
    }
    
    private func bindDistance() {
        nearByStop
            .withLatestFrom(
                locationService.currentLocation
            ) { response, location in
                (response, location)
            }
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, tuple in
                    let (response, startPoint) = tuple
                    guard let endPointLatitude = Double(response.latitude),
                          let endPointLongitude = Double(response.longitude)
                    else { return }
                    let distance = Int(
                        CLLocation(
                            latitude: endPointLatitude,
                            longitude: endPointLongitude
                        )
                        .distance(from: startPoint)
                    )
                    let distanceStr: String
                    switch distance {
                    case ..<1000:
                        distanceStr = "\(distance)m"
                    case Int.max:
                        distanceStr = "측정거리 초과"
                    default:
                        distanceStr =  "\(distance / 1000)km"
                    }
                    useCase.distanceFromNearByStop.onNext(distanceStr)
                }
            )
            .disposed(by: disposeBag)
    }
}
