//
//  Favorites.swift
//  Domain
//
//  Created by gnksbm on 1/26/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct Favorites {
    let requests: [StationArrivalInfoRequest]
    
    public init(requests: [StationArrivalInfoRequest]) {
        self.requests = requests
    }
}
