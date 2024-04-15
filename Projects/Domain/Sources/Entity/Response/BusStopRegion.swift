//
//  BusStopRegion.swift
//  Domain
//
//  Created by gnksbm on 4/3/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public enum BusStopRegion: Hashable {
    case seoul(responses: [BusStopInfoResponse])
}
