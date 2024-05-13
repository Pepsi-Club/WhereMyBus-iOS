//
//  DefaultNetworkService.swift
//  Network
//
//  Created by gnksbm on 2023/12/27.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift
import FirebaseAnalytics

public final class DefaultNetworkService: NetworkService {
    public init() { }
    
    public func request(endPoint: EndPoint) -> Observable<Data> {
        .create { observer in
            guard let urlRequest = endPoint.toURLRequest
            else {
                observer.onError(NetworkError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(
                with: urlRequest
            ) { data, response, error in
                if let error {
                    observer.onError(NetworkError.transportError(error))
                    return
                }
                
                guard let httpURLResponse = response as? HTTPURLResponse
                else { return }
                guard 200..<300 ~= httpURLResponse.statusCode
                else {
                    observer.onError(
                        NetworkError.invalidStatusCode(
                            httpURLResponse.statusCode
                        )
                    )
                    #if DEBUG
                    if let url = urlRequest.url,
                       let httpMethod = urlRequest.httpMethod,
                       let data = urlRequest.httpBody,
                       let httpBody = String(
                        data: data,
                        encoding: .utf8
                       ) {
                        print(
                            url,
                            httpMethod,
                            httpBody,
                            separator: "\n"
                        )
                    }
                    if let data,
                    let json = String(
                        data: data,
                        encoding: .utf8
                    ) {
                        print(
                            json
                        )
                    }
                    #endif
                    return
                }
                
                guard let data
                else {
                    observer.onError(NetworkError.invalidData)
                    return
                }
                observer.onNext(data)
                observer.onCompleted()
            }.resume()
            
            return Disposables.create()
        }
    }
}
