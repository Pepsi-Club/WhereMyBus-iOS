//
//  StationArrivalInfoRequest.swift
//  Domain
//
//  Created by gnksbm on 1/26/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct StationArrivalInfoRequest {
    public let stationId: String
    
    public init(stationId: String) {
        self.stationId = stationId
    }
}
