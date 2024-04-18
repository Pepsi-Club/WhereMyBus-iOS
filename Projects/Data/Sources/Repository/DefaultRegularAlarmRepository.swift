//
//  DefaultRegularAlarmRepository.swift
//  Data
//
//  Created by gnksbm on 4/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import CoreDataService
import Domain
import NetworkService

import RxSwift

public final class DefaultRegularAlarmRepository: RegularAlarmRepository {
    private let coreDataService: CoreDataService
    private let networkService: NetworkService
    
    public let currentRegularAlarm = BehaviorSubject<[RegularAlarmResponse]>(
        value: []
    )
    private let disposeBag = DisposeBag()
    
    public init(
        coreDataService: CoreDataService,
        networkService: NetworkService
    ) {
        self.coreDataService = coreDataService
        self.networkService = networkService
        bindStoreStatus()
    }
    
    public func createRegularAlarm(
        response: RegularAlarmResponse,
        completion: @escaping () -> Void
    ) {
        let request = response.toAddRequest
        networkService.request(
            endPoint: AddRegularAlarmEndPoint(
                request: request
            )
        )
        .decode(
            type: AddRegularAlarmDTO.self,
            decoder: JSONDecoder()
        )
        .map { dto in
            dto.toDomain(request: request)
        }
        .withUnretained(self)
        .subscribe(
            onNext: { repository, response in
                do {
                    try repository.coreDataService.saveUniqueData(
                        data: response,
                        uniqueKeyPath: \.requestId
                    )
                    let currentAlarms = try repository.currentRegularAlarm
                        .value()
                    repository.currentRegularAlarm.onNext(
                        currentAlarms + [response]
                    )
                    completion()
                } catch {
                    #if DEBUG
                    print(error.localizedDescription)
                    #endif
                }
            },
            onError: { error in
                #if DEBUG
                print(error.localizedDescription)
                #endif
            }
        )
        .disposed(by: disposeBag)
    }
    
    public func updateRegularAlarm(
        response: RegularAlarmResponse,
        completion: @escaping () -> Void
    ) {
        deleteRegularAlarm(
            response: response
        ) { [weak self] in
            self?.createRegularAlarm(
                response: response,
                completion: completion
            )
        }
    }
    
    public func deleteRegularAlarm(
        response: RegularAlarmResponse,
        completion: @escaping () -> Void
    ) {
        networkService.request(
            endPoint: RemoveRegularAlarmEndPoint(
                request: response.toRemoveRequest
            )
        )
        .decode(
            type: RemoveRegularAlarmDTO.self,
            decoder: JSONDecoder()
        )
        .map { _ in
            response
        }
        .withUnretained(self)
        .subscribe(
            onNext: { repository, response in
                do {
                    try repository.coreDataService.delete(
                        data: response,
                        uniqueKeyPath: \.requestId
                    )
                    let currentAlarms = try repository.currentRegularAlarm
                        .value()
                    repository.currentRegularAlarm.onNext(
                        currentAlarms.filter {
                            $0.requestId != response.requestId
                        }
                    )
                    completion()
                } catch {
                    #if DEBUG
                    print(error.localizedDescription)
                    #endif
                }
            },
            onError: { error in
                #if DEBUG
                print(error.localizedDescription)
                #endif
            }
        )
        .disposed(by: disposeBag)
    }
    
    private func bindStoreStatus() {
        coreDataService.storeStatus
            .withUnretained(self)
            .subscribe(
                onNext: { repository, storeStatus in
                    if storeStatus == .loaded {
                        DispatchQueue.global().async {
                            repository.migrateAlarmV2()
                        }
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func fetchRegularAlarm() {
        coreDataService.fetch(type: RegularAlarmResponse.self)
            .withUnretained(self)
            .subscribe(
                onNext: { repository, alarmList in
                    repository.currentRegularAlarm.onNext(alarmList)
                    repository.syncRegularAlarms(responses: alarmList)
                }
            )
            .disposed(by: disposeBag)
    }
}
// MARK: 로컬 / 서버 싱크
extension DefaultRegularAlarmRepository {
    private func syncRegularAlarms(responses: [RegularAlarmResponse]) {
        networkService.request(endPoint: FetchRegularAlarmEndPoint())
            .decode(
                type: [FetchRegularAlarmDTO].self,
                decoder: JSONDecoder()
            )
            .withUnretained(self)
            .subscribe(
                onNext: { repository, dtoArr in
                    switch dtoArr.validateSync(localResponses: responses) {
                    case .synced:
                        break
                    case .localMissing(alarmIds: let alarmIds):
                        repository.removeUnsyncedServerAlarm(alarmIds: alarmIds)
                    case .serverMissing(responses: let responses):
                        repository.createUnsyncedServerAlarm(
                            responses: responses
                        )
                    case .bothMissing(
                        localMissingAlarmIds: let localMissingAlarmIds,
                        serverMissingResponses: let serverMissingResponses
                    ):
                        repository.removeUnsyncedServerAlarm(
                            alarmIds: localMissingAlarmIds
                        )
                        repository.createUnsyncedServerAlarm(
                            responses: serverMissingResponses
                        )
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func createUnsyncedServerAlarm(responses: [RegularAlarmResponse]) {
        responses.forEach { response in
            networkService.request(
                endPoint: AddRegularAlarmEndPoint(
                    request: response.toAddRequest
                )
            )
            .decode(
                type: AddRegularAlarmDTO.self,
                decoder: JSONDecoder()
            )
            .withUnretained(self)
            .subscribe(
                onNext: { repository, dto in
                    #if DEBUG
                    print("⏰ 서버에 없는 알람 등록 완료")
                    #endif
                    let newResponse = RegularAlarmResponse(
                        requestId: dto.alarmId,
                        busStopId: response.busStopId,
                        busStopName: response.busStopName,
                        busId: response.busId,
                        busName: response.busName,
                        time: response.time,
                        weekday: response.weekday,
                        adirection: response.adirection
                    )
                    do {
                        try repository.coreDataService.delete(
                            data: response,
                            uniqueKeyPath: \.requestId
                        )
                        try repository.coreDataService.saveUniqueData(
                            data: newResponse,
                            uniqueKeyPath: \.requestId
                        )
                        let currentResponse = try repository.currentRegularAlarm
                            .value()
                        let updatedResponse = currentResponse
                            .filter { $0 != response } + [ newResponse ]
                        repository.currentRegularAlarm.onNext(updatedResponse)
                        #if DEBUG
                        print("⏰ 서버에 없는 알람 등록 후 새로운 ID 로컬 저장 성공")
                        #endif
                    } catch {
                        #if DEBUG
                        print("⏰ 서버에 없는 알람 등록 후 새로운 ID 로컬 저장 실패")
                        print(error.localizedDescription)
                        #endif
                    }
                },
                onError: { error in
                    #if DEBUG
                    print(error.localizedDescription)
                    #endif
                }
            )
            .disposed(by: disposeBag)
        }
    }
    
    private func removeUnsyncedServerAlarm(alarmIds: [String]) {
        alarmIds.forEach { alarmId in
            networkService.request(
                endPoint: RemoveRegularAlarmEndPoint(
                    request: .init(alarmId: alarmId)
                )
            )
            .decode(
                type: RemoveRegularAlarmDTO.self,
                decoder: JSONDecoder()
            )
            .subscribe(
                onNext: { dto in
                    #if DEBUG
                    print("⏰ 로컬에 없는 알람 제거 결과: \(dto)")
                    #endif
                },
                onError: { error in
                    #if DEBUG
                    print("⏰ 로컬에 없는 알람 제거 실패")
                    print(error.localizedDescription)
                    #endif
                }
            )
            .disposed(by: disposeBag)
        }
    }
}
// MARK: 마이그레이션_v2 adirection
extension DefaultRegularAlarmRepository {
    private func migrateAlarmV2() {
        coreDataService.fetch(type: RegularAlarmResponse.self)
            .map { legacyAlarmList in
                legacyAlarmList.filter { $0.adirection.isEmpty }
            }
            .withUnretained(self)
            .flatMap { repository, legacyAlarmList in
                repository.fetchLegacyFavoritesToBusStop(
                    legacyAlarmList: legacyAlarmList
                )
                .map { busStopResponse in
                    (busStopResponse, legacyAlarmList)
                }
            }
            .withUnretained(self)
            .subscribe(
                onNext: { repository, tuple in
                    repository.updateLegacyToNewAlarm(
                        busStopResponse: tuple.0,
                        legacyAlarmList: tuple.1
                    )
                },
                onError: { [weak self] _ in
                    self?.fetchRegularAlarm()
                },
                onCompleted: { [weak self] in
                    self?.fetchRegularAlarm()
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func fetchLegacyFavoritesToBusStop(
        legacyAlarmList: [RegularAlarmResponse]
    ) -> Observable<BusStopArrivalInfoResponse> {
        Observable.merge(
            legacyAlarmList.filterDuplicatedBusStop()
                .map { legacyAlarm in
                    networkService.request(
                        endPoint: BusStopArrivalInfoEndPoint(
                            arsId: legacyAlarm.busStopId
                        )
                    )
                    .decode(
                        type: BusStopArrivalInfoDTO.self,
                        decoder: JSONDecoder()
                    )
                    .compactMap { dto in
                        dto.toDomain
                    }
                }
        )
    }
    
    private func updateLegacyToNewAlarm(
        busStopResponse: BusStopArrivalInfoResponse,
        legacyAlarmList: [RegularAlarmResponse]
    ) {
        legacyAlarmList.forEach { legacyAlarm in
            guard let busInfo = busStopResponse.buses.first(
                where: { bus in
                    bus.busId == legacyAlarm.busId
                }
            )
            else { return }
            let newAlarm = RegularAlarmResponse(
                requestId: legacyAlarm.requestId,
                busStopId: legacyAlarm.busStopId,
                busStopName: legacyAlarm.busStopName,
                busId: legacyAlarm.busId,
                busName: legacyAlarm.busName,
                time: legacyAlarm.time,
                weekday: legacyAlarm.weekday,
                adirection: busInfo.adirection
            )
            updateRegularAlarm(response: newAlarm) {
                #if DEBUG
                print(
                    "⏰ \(newAlarm.busStopName)",
                    "\(newAlarm.busStopName)",
                    "\(newAlarm.adirection)",
                    "마이그레이션 완료"
                )
                #endif
                
            }
        }
    }
    
}
