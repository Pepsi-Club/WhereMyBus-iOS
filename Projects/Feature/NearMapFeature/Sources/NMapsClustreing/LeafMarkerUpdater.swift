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

public class LeafMarkerUpdater: NMCDefaultLeafMarkerUpdater {
    let selectedBusStopId = BehaviorSubject<String>(value: "")
    
    private var selectedMarker: NMFMarker? {
        didSet {
            oldValue?.iconImage = unselectedImg
            selectedMarker?.iconImage = selectedImg
        }
    }
    
    private var selectedImg: NMFOverlayImage {
        .init(
            image: DesignSystemAsset.locationPin.image
                .resize(45, 45),
            reuseIdentifier: "selectedbusStop"
        )
    }
    
    private var unselectedImg: NMFOverlayImage {
        .init(
            image: DesignSystemAsset.locationPingray.image
                .resize(45, 45),
            reuseIdentifier: "unselectedbusStop"
        )
    }
    
    public override func updateLeafMarker(
        _ info: NMCLeafMarkerInfo,
        _ marker: NMFMarker
    ) {
        super.updateLeafMarker(info, marker)
        if let key = info.key as? BusStopClusteringKey {
            var busStopId = String(key.identifier)
            while busStopId.count < 5 {
                busStopId = "0" + busStopId
            }
            if let selectedBusStopId = try? selectedBusStopId.value() {
                if busStopId == selectedBusStopId {
                    marker.iconImage = selectedImg
                    selectedMarker = marker
                } else {
                    marker.iconImage = unselectedImg
                }
            } else {
                marker.iconImage = unselectedImg
            }
            // YES일 경우 이벤트를 소비합니다. 그렇지 않을 경우 NMFMapView까지 이벤트가 전달되어
            // NMFMapViewTouchDelegate의 mapView:didTapMap:point:가 호출됩니다.
            marker.touchHandler = { [weak self] _ in
                self?.selectedBusStopId.onNext(busStopId)
                self?.selectedMarker = marker
                return true
            }
        }
    }
}
