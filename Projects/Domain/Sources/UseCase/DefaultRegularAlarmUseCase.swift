//
//  DefaultRegularAlarmUseCase.swift
//  Domain
//
//  Created by gnksbm on 3/10/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public class DefaultRegularAlarmUseCase: RegularAlarmUseCase {
    private let localNotificationService: LocalNotificationService
    private let regularAlarmRepository: RegularAlarmRepository
    
    public let fetchedAlarm = PublishSubject<[RegularAlarmResponse]>()
    private let disposeBag = DisposeBag()
    
    public init(
        localNotificationService: LocalNotificationService,
        regularAlarmRepository: RegularAlarmRepository
    ) {
        self.localNotificationService = localNotificationService
        self.regularAlarmRepository = regularAlarmRepository
    }
    
    public func fetchAlarm() {
        regularAlarmRepository.currentRegularAlarm
            .withUnretained(self)
            .map { useCase, responses in
                useCase.sortResponses(responses: responses)
            }
            .bind(to: fetchedAlarm)
            .disposed(by: disposeBag)
        DispatchQueue.global().async { [weak self] in
            self?.migrateRegularAlarm()
        }
    }
    
    public func removeAlarm(response: RegularAlarmResponse) throws {
        regularAlarmRepository.deleteRegularAlarm(response: response) {
            #if DEBUG
            print("Remove completed")
            #endif
        }
    }
    
    private func migrateRegularAlarm() {
        localNotificationService.fetchRegularAlarm()
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .map { useCase, responses in
                useCase.replaceWeekday(responses: responses)
            }
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, responses in
                    responses.forEach { response in
                        useCase.regularAlarmRepository.createRegularAlarm(
                            response: response
                        ) {
                            useCase.removeLegacy(response: response)
                        }
                        
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func sortResponses(
        responses: [RegularAlarmResponse]
    ) -> [RegularAlarmResponse] {
        responses.sorted {
            guard let firstValue = $0.weekday.sorted().first,
                  let secondValue = $1.weekday.sorted().first
            else { return true }
            let dateResult = $0.time < $1.time
            let weekDayResult = firstValue < secondValue
            return firstValue == secondValue ?
            dateResult : weekDayResult
        }
    }
    
    private func replaceWeekday(
        responses: [RegularAlarmResponse]
    ) -> [RegularAlarmResponse] {
        responses.map { response in
            let newWeekdy = response.weekday.map { rawValue in
                rawValue - 1
            }
            return RegularAlarmResponse(
                requestId: response.requestId,
                busStopId: response.busStopId,
                busStopName: response.busStopName,
                busId: response.busId,
                busName: response.busName,
                time: response.time,
                weekday: newWeekdy,
                adirection: response.adirection
            )
        }
    }
    
    private func removeLegacy(response: RegularAlarmResponse) {
        do {
            try localNotificationService.removeRegularAlarm(response: response)
        } catch {
            #if DEBUG
            print(error.localizedDescription)
            #endif
        }
    }
}
