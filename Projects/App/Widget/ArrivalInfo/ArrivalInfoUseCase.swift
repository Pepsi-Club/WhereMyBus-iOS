//
//  ArrivalInfoUseCase.swift
//  App
//
//  Created by gnksbm on 4/8/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

@available(iOS 17.0, *)
final class ArrivalInfoUseCase {
    var responses = [BusStopArrivalInfoResponse]()
    
    func loadBusStopArrivalInfo() {
        guard let datas = 
            UserDefaults.appGroup.array(forKey: "arrivalResponse") as? [Data]
        else {
            print("Failed to load or cast user defaults data.")
            return
        }
        responses = datas.compactMap {
            try? $0.decode(type: BusStopArrivalInfoResponse.self)
        }
    }
}
