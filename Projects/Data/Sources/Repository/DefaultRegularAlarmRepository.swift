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
        do {
            let responses = try coreDataService.fetch(
                type: RegularAlarmResponse.self
            )
            currentRegularAlarm.onNext(responses)
            syncRegularAlarms(responses: responses)
        } catch {
            currentRegularAlarm.onError(error)
        }
    }
    
    private func migrateAlarmV2() {
        do {
            let legacyAlarms = try coreDataService
                .fetch(
                    type: RegularAlarmResponse.self
                )
                .filter { legacyResponse in
                    legacyResponse.adirection.isEmpty
                }
                .filterDuplicatedBusStop()
            Observable.merge(
                legacyAlarms.map { legacyAlarm in
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
            .withUnretained(self)
            .subscribe(
                onNext: { repository, busStopResponse in
                    legacyAlarms.forEach { legacyAlarm in
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
                        repository.updateRegularAlarm(
                            response: newAlarm
                        ) {
                            
                        }
                    }
                },
                onDisposed: { [weak self] in
                    self?.fetchRegularAlarm()
                }
            )
            .disposed(by: disposeBag)
        } catch {
            currentRegularAlarm.onError(error)
        }
    }
    
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
                        print("로컬 싱크 성공")
                        #endif
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
            ) // 성공, Error에 따라 추가 작업을 해줘야할지 고민입니다
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
                    print(dto)
                    print("id: \(alarmId)")
                    #endif
                },
                onError: { error in
                    #if DEBUG
                    print(error.localizedDescription)
                    #endif
                }
            ) // 성공, Error에 따라 추가 작업을 해줘야할지 고민입니다
            .disposed(by: disposeBag)
        }
    }
}
