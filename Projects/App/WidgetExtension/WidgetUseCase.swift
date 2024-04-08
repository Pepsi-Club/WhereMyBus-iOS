//
//  WidgetUseCase.swift
//  App
//
//  Created by gnksbm on 4/8/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

final class WidgetUseCase {
    var responses = [BusStopArrivalInfoResponse]()
    
    func fetchUserDefaultValue() {
        guard let datas = UserDefaults.appGroup?.array(
            forKey: "arrivalResponse"
        ) as? [Data]
        else { return }
        responses = datas.compactMap {
            return try? $0.decode(type: BusStopArrivalInfoResponse.self)
        }
    }
}
