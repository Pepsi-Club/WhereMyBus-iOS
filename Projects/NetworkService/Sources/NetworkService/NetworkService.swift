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
    func request(endPoint: EndPoint) async throws -> Data
    
    @available(
        *,
         deprecated,
         renamed: "request(endPoint:)",
         message: "이 메서드는 제거될 예정입니다. async 함수 request(endPoint:)를 사용하세요."
    )
    func request(endPoint: EndPoint) -> Observable<Data>
    @available(
        *,
         deprecated,
         renamed: "request(endPoint:)",
         message: "이 메서드는 제거될 예정입니다. async 함수 request(endPoint:)를 사용하세요."
    )
    func request<T: Decodable>(
        endPoint: EndPoint,
        responseType: T.Type
    ) -> Single<Result<T, Error>>
}
