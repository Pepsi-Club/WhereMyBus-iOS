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
                    repository.fetchRegularAlarm()
                    completion()
                } catch {
                    print(error.localizedDescription)
                }
            },
            onError: { error in
                print(error.localizedDescription)
            }
        )
        .disposed(by: disposeBag)
    }
    
    public func updateRegularAlarm(
        response: RegularAlarmResponse
    ) {
        deleteRegularAlarm(
            response: response
        ) { [weak self] in
            self?.createRegularAlarm(
                response: response,
                completion: { }
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
                    repository.fetchRegularAlarm()
                    completion()
                } catch {
                    print(error.localizedDescription)
                }
            },
            onError: { error in
                print(error.localizedDescription)
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
        } catch {
            currentRegularAlarm.onError(error)
        }
    }
}
