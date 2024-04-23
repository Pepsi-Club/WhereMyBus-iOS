//
//  NearByStopProvider.swift
//  Widget
//
//  Created by gnksbm on 4/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation
import WidgetKit

import Core
import Domain

import RxSwift

struct NearByStopProvider: TimelineProvider {
    @Injected(NearMapUseCase.self) var useCase: NearMapUseCase
    
    private let disposeBag = DisposeBag()
    
    func placeholder(
        in context: Context
    ) -> NearByStopEntry {
        NearByStopEntry.mock
    }
    
    func getSnapshot(
        in context: Context,
        completion: @escaping (NearByStopEntry) -> Void
    ) {
        completion(NearByStopEntry.mock)
    }
    
    // 리프레시되는 주기 및 실질적으로 보여질 데이터를 처리하는 공간
    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<NearByStopEntry>) -> Void
    ) {
//        이때는 위젯에 잘 나옴
        let timeline = Timeline(
            entries: [NearByStopEntry.mock],
            policy: .never
        )
        completion(timeline)
        
// 이렇게 됐을 때 위젯에 데이터 안나옴
//        useCase.getNearByStopInfo()
//            .subscribe(onNext: { response, distance in
//                var entries: [NearByStopEntry] = [NearByStopEntry(
//                    date: Date(),
//                    busStopName: response.busStopName,
//                    distance: Int(distance) ?? 0
//                )]
//
//                // 데이터 업데이트를 위한 타임라인 생성
//                let timeline = Timeline(
//                    entries: entries,
//                    policy: .after(Date().addingTimeInterval(60 * 30))
//                )
//
//                completion(timeline)
//            })
//            .disposed(by: disposeBag)
        
    }
    
    typealias Entry = NearByStopEntry
}
