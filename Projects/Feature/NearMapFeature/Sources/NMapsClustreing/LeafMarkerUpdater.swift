//
//  LeafMarkerUpdater.swift
//  NearMapFeature
//
//  Created by gnksbm on 4/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import DesignSystem

import NMapsMap
import RxSwift

final class LeafMarkerUpdater: NMCDefaultLeafMarkerUpdater {
    let selectedBusStopId = BehaviorSubject<String>(value: "")
    private let disposeBag = DisposeBag()
    
    override func updateLeafMarker(
        _ info: NMCLeafMarkerInfo,
        _ marker: NMFMarker
    ) {
        super.updateLeafMarker(info, marker)
        if let key = info.key as? BusStopClusteringKey {
            selectedBusStopId
                .distinctUntilChanged()
                .subscribe(
                    onNext: { identifier in
                        if String(key.identifier) == identifier {
                            marker.captionText = identifier
                        } else {
                            marker.captionText = ""
                        }
                    },
                    onDisposed: {
                        print("disposed")
                    }
                )
                .disposed(by: disposeBag)
            marker.iconImage = NMFOverlayImage(
                image: DesignSystemAsset.mapBusStop.image,
                reuseIdentifier: "busStop"
            )
            // YES일 경우 이벤트를 소비합니다. 그렇지 않을 경우 NMFMapView까지 이벤트가 전달되어
            // NMFMapViewTouchDelegate의 mapView:didTapMap:point:가 호출됩니다.
            marker.touchHandler = { [weak self] _ in
                self?.selectedBusStopId.onNext(String(key.identifier))
                return true
            }
        }
    }
}
