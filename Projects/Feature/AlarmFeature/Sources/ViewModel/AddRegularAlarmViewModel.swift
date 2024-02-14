//
//  AddRegularAlarmViewModel.swift
//  AlarmFeature
//
//  Created by gnksbm on 2/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain
import FeatureDependency

import RxSwift
import RxRelay

final class AddRegularAlarmViewModel: ViewModel {
    private let alarmToEdit: RegularAlarmResponse?
    private let coordinator: AddRegularAlarmCoordinator
    
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
            selectedDate: .init(),
            selectedWeekDay: .init(value: [])
        )
        if let alarmToEdit {
            output.title.accept("수정하기")
            output.selectedBusInfo.accept(
                "\(alarmToEdit.busStopName), \(alarmToEdit.busName)"
            )
            output.selectedDate.onNext(alarmToEdit.time)
            output.selectedWeekDay.accept(alarmToEdit.weekDay)
        }
        
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
                    viewModel.coordinator.complete()
                }
            )
            .disposed(by: disposeBag)
        
        return output
    }
}

extension AddRegularAlarmViewModel {
    struct Input { 
        let searchBtnTapEvent: Observable<Void>
        let dateSelectEvent: Observable<Date>
        let weekDayBtnTapEvent: Observable<Int>
        let completeBtnTapEvent: Observable<Void>
    }
    
    struct Output { 
        let title: BehaviorRelay<String>
        let selectedBusInfo: BehaviorRelay<String>
        let selectedDate: PublishSubject<Date>
        let selectedWeekDay: BehaviorRelay<[Int]>
    }
}
