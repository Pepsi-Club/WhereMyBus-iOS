//
//  NearByStopProvider.swift
//  Widget
//
//  Created by gnksbm on 4/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import WidgetKit

import Core
import Data
import Domain

import RxSwift

struct NearByStopProvider: TimelineProvider {
    private let useCase = DefaultNearByStopUseCase(
        stationListRepository: DefaultStationListRepository(),
        locationService: DefaultLocationService()
    )
    
    private let disposeBag = DisposeBag()
    
    func placeholder(
        in context: Context
    ) -> NearByStopEntry {
        NearByStopEntry(
            date: .now,
            busStopName: "강남역 2호선",
            distance: "60m"
        )
    }
    
    func getSnapshot(
        in context: Context,
        completion: @escaping (NearByStopEntry) -> Void
    ) {
        completion(
            NearByStopEntry(
                date: .now,
                busStopName: "강남역 2호선",
                distance: "60m"
            )
        )
    }
    
    // 리프레시되는 주기 및 실질적으로 보여질 데이터를 처리하는 공간
    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<NearByStopEntry>) -> Void
    ) {
        
        useCase.updateNearByStop()
            .subscribe(onNext: { response, distance in
                
                var entries: [NearByStopEntry] = [
                    NearByStopEntry(
                        date: .now,
                        busStopName: response.busStopName,
                        distance: distance
                    )
                ]
                                
                // 데이터 업데이트를 위한 타임라인 생성
                let timeline = Timeline(
                    entries: entries,
                    policy: .after(.now.addingTimeInterval(60))
                )
                print("❤️‍🔥 \(timeline)")
                
                completion(timeline)
            })
            .disposed(by: disposeBag)

    }
    
    typealias Entry = NearByStopEntry
}
