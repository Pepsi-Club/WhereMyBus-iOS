//
//  AddRegularAlarmViewModel.swift
//  AlarmFeature
//
//  Created by gnksbm on 2/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift
import RxRelay

final class AddRegularAlarmViewModel: ViewModel {
    private let alarmToEdit: RegularAlarmResponse?
    private let coordinator: AddRegularAlarmCoordinator
    @Injected(AddRegularAlarmUseCase.self) var useCase: AddRegularAlarmUseCase
    
    private let disposeBag = DisposeBag()
    
    init(
        alarmToEdit: RegularAlarmResponse? = nil,
        coordinator: AddRegularAlarmCoordinator
    ) {
        self.alarmToEdit = alarmToEdit
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator.finish()
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            title: .init(value: "추가하기"),
            regularAlarm: .init(
                value: .init(
                    busStopId: "",
                    busStopName: "",
                    busId: "",
                    busName: "",
                    time: .now,
                    weekDay: []
                )
            )
        )
        if let alarmToEdit {
            output.title.accept("수정하기")
            output.regularAlarm.accept(alarmToEdit)
        }
        
        input.viewWillAppear
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.useCase.checkNotificationAuth()
                }
            )
            .disposed(by: disposeBag)
        
        input.searchBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.coordinator.startSearchFlow()
                }
            )
            .disposed(by: disposeBag)
        
        input.dateSelectEvent
            .subscribe(
                onNext: { date in
                    let dataToUpdated = output.regularAlarm.value
                    let updatedAlarm = RegularAlarmResponse(
                        requestId: dataToUpdated.requestId,
                        busStopId: dataToUpdated.busStopId,
                        busStopName: dataToUpdated.busStopName,
                        busId: dataToUpdated.busId,
                        busName: dataToUpdated.busName,
                        time: date,
                        weekDay: dataToUpdated.weekday
                    )
                    output.regularAlarm.accept(updatedAlarm)
                }
            )
            .disposed(by: disposeBag)
        
        input.weekDayBtnTapEvent
            .subscribe(
                onNext: { rawValue in
                    let dataToUpdated = output.regularAlarm.value
                    let newWeekday: [Int]
                    if dataToUpdated.weekday.contains(rawValue) {
                        newWeekday = dataToUpdated.weekday.filter {
                            $0 != rawValue
                        }
                    } else {
                        newWeekday = dataToUpdated.weekday + [rawValue]
                    }
                    let updatedAlarm = RegularAlarmResponse(
                        requestId: dataToUpdated.requestId,
                        busStopId: dataToUpdated.busStopId,
                        busStopName: dataToUpdated.busStopName,
                        busId: dataToUpdated.busId,
                        busName: dataToUpdated.busName,
                        time: dataToUpdated.time,
                        weekDay: newWeekday
                    )
                    output.regularAlarm.accept(updatedAlarm)
                }
            ).disposed(by: disposeBag)
        
        input.completeBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    switch output.title.value {
                    case "추가하기":
                        viewModel.useCase.addNewAlarm(
                            response: output.regularAlarm.value
                        )
                        viewModel.coordinator.complete()
                    case "수정하기":
                        viewModel.useCase.editAlarm(
                            response: output.regularAlarm.value
                        )
                        viewModel.coordinator.complete()
                    default:
                        print("\(String(describing: self)): 잘못된 타이틀")
                    }
                }
            )
            .disposed(by: disposeBag)
        
        return output
    }
}

extension AddRegularAlarmViewModel {
    struct Input { 
        let viewWillAppear: Observable<Void>
        let searchBtnTapEvent: Observable<Void>
        let dateSelectEvent: Observable<Date>
        let weekDayBtnTapEvent: Observable<Int>
        let completeBtnTapEvent: Observable<Void>
    }
    
    struct Output { 
        let title: BehaviorRelay<String>
        let regularAlarm: BehaviorRelay<RegularAlarmResponse>
    }
}
