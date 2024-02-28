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
    @Injected(RegularAlarmUseCase.self) var useCase: RegularAlarmUseCase
    
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
            selectedBusInfo: .init(value: "정류장 및 버스 찾기"),
            selectedDate: .init(value: .now),
            selectedWeekDay: .init(value: [])
        )
        if let alarmToEdit {
            output.title.accept("수정하기")
            output.selectedBusInfo.accept(
                "\(alarmToEdit.busStopName), \(alarmToEdit.busName)"
            )
            output.selectedDate.accept(alarmToEdit.time)
            output.selectedWeekDay.accept(alarmToEdit.weekDay)
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
            .bind(to: output.selectedDate)
            .disposed(by: disposeBag)
        
        input.weekDayBtnTapEvent
            .subscribe(
                onNext: { rawValue in
                    if output.selectedWeekDay.value.contains(rawValue) {
                        output.selectedWeekDay.accept(
                            output.selectedWeekDay.value.filter {
                                $0 != rawValue
                            }
                        )
                    } else {
                        output.selectedWeekDay.accept(
                            output.selectedWeekDay.value + [rawValue]
                        )
                    }
                }
            ).disposed(by: disposeBag)
        
        input.completeBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    let selectedBusInfo = output.selectedBusInfo.value
                        .split(separator: " ")
                        .map { String($0) }
                    guard let busStopName = selectedBusInfo.first,
                          let busName = selectedBusInfo.last
                    else { return }
                    viewModel.useCase.addNewAlarm(
                        response: .init(
                            busStopId: "busStopId",
                            busStopName: busStopName,
                            busId: "busId",
                            busName: busName,
                            time: output.selectedDate.value,
                            weekDay: output.selectedWeekDay.value
                        )
                    )
                    viewModel.coordinator.complete()
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
        let selectedBusInfo: BehaviorRelay<String>
        let selectedDate: BehaviorRelay<Date>
        let selectedWeekDay: BehaviorRelay<[Int]>
    }
}
