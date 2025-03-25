//
//  NetworkService.swift
//  Data
//
//  Created by gnksbm on 2023/12/27.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol NetworkService {
    func request(endPoint: EndPoint) -> Observable<Data>
    func request<T: Decodable>(
        endPoint: EndPoint,
        responseType: T.Type
    ) -> Single<Result<T, Error>>
}
