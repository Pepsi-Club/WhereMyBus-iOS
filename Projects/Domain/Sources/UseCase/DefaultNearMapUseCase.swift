//
//  DefaultNearMapUseCase.swift
//  Domain
//
//  Created by Muker on 2/14/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import CoreLocation
import Foundation

import RxSwift
import RxCocoa

public final class DefaultNearMapUseCase: NearMapUseCase {
    private let stationListRepository: StationListRepository
    private let locationService: LocationService
    
    public let locationStatus = BehaviorSubject<LocationStatus>(
        value: .notDetermined
    )
    private let disposeBag = DisposeBag()
    
    public init(
        stationListRepository: StationListRepository,
        locationService: LocationService
    ) {
        self.stationListRepository = stationListRepository
        self.locationService = locationService
        bindLocationStatus()
    }
    
    public func requestAuthorize() {
        locationService.authorize()
    }
    
    public func getNearByStopInfo(
    ) -> Observable<(BusStopInfoResponse, String)> {
        locationService.locationStatus
            .withUnretained(self)
            .map { useCase, status in
                var response: BusStopInfoResponse
                var distanceStr: String
                let requestMessage = "주변 정류장을 확인하려면 위치 정보를 동의해주세요."
                let errorMessage = "오류가 발생했습니다. 관리자에게 문의해주세요."
                switch status {
                case .authorized(let location), .alwaysAllowed(let location):
                    (response, distanceStr) = useCase.stationListRepository
                        .getNearByStopInfo(startPointLocation: location)
                case .notDetermined, .denied:
                    response = .init(
                        busStopName: requestMessage,
                        busStopId: "권한 설정하러 가기",
                        direction: "",
                        longitude: "126.979620",
                        latitude: "37.570028"
                    )
                    distanceStr = ""
                case .error:
                    response = .init(
                        busStopName: errorMessage,
                        busStopId: "",
                        direction: "",
                        longitude: "126.979620",
                        latitude: "37.570028"
                    )
                    distanceStr = ""
                }
                return (response, distanceStr)
            }
    }
    
    public func getSelectedBusStop(
        busStopId: String
    ) -> (BusStopInfoResponse, String) {
        let errorResponse = BusStopInfoResponse(
            busStopName: "정류장 정보를 찾을 수 없습니다.",
            busStopId: "",
            direction: "",
            longitude: "",
            latitude: ""
        )
        let errorDistance = ""
        do {
            let stationList = try stationListRepository.stationList.value()
            let selectedBusStop = stationList.first { response in
                response.busStopId == busStopId
            }
            if let selectedBusStop {
                let distance = locationService.getDistance(
                    response: selectedBusStop
                )
                return (selectedBusStop, distance)
            } else {
                return (errorResponse, errorDistance)
            }
        } catch {
            return (errorResponse, errorDistance)
        }
    }
    
    public func getNearBusStopList(
        longitudeRange: ClosedRange<Double>,
        latitudeRange: ClosedRange<Double>
    ) -> [BusStopInfoResponse] {
        do {
            let stationList = try stationListRepository.stationList.value()
            return stationList.filter { response in
                guard let longitude = Double(response.longitude),
                      let latitude = Double(response.latitude)
                else { return false }
                return longitudeRange ~= longitude &&
                latitudeRange ~= latitude
            }
        } catch {
            return []
        }
    }
    
    private func bindLocationStatus() {
        locationService.locationStatus
            .bind(to: locationStatus)
            .disposed(by: disposeBag)
    }
}
