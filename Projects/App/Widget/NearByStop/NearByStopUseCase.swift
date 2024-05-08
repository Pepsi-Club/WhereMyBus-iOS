//
//  NearByStopUseCase.swift
//  Widget
//
//  Created by Jisoo HAM on 4/25/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

import RxSwift

public protocol NearByStopUseCase {
    func updateNearByStop() -> Observable<(BusStopInfoResponse, String)>
}
