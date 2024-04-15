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
        fetchRegularAlarm()
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
                    try repository.coreDataService.save(data: response)
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
        .map { dto in
            print(dto.message)
            return response
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
                        currentAlarms.filter { $0 != response }
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
            .subscribe(
                onNext: { dto in
                    #if DEBUG
                    print(dto)
                    print("id: \(response.requestId)")
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
