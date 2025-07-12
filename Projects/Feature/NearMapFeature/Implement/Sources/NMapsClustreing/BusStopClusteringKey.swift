//
//  BusStopClusteringKey.swift
//  NearMapFeature
//
//  Created by gnksbm on 4/6/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import NMapsMap

final class BusStopClusteringKey: NSObject, NMCClusteringKey {
    let identifier: Int
    let position: NMGLatLng

    init(identifier: Int, position: NMGLatLng) {
        self.identifier = identifier
        self.position = position
    }

    static func markerKey(
        withIdentifier identifier: Int,
        position: NMGLatLng
    ) -> BusStopClusteringKey {
        return BusStopClusteringKey(
            identifier: identifier,
            position: position
        )
    }

    override func isEqual(_ o: Any?) -> Bool {
        guard let o = o as? BusStopClusteringKey else {
            return false
        }
        if self === o {
            return true
        }

        return o.identifier == self.identifier
    }

    override var hash: Int {
        return self.identifier
    }

    func copy(with zone: NSZone? = nil) -> Any {
        return BusStopClusteringKey(
            identifier: self.identifier,
            position: self.position
        )
    }
}
