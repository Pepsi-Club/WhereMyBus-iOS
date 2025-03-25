//
//  DefaultNetworkService.swift
//  Network
//
//  Created by gnksbm on 2023/12/27.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public final class DefaultNetworkService: NetworkService {
    public init() { }
    
    public func request(endPoint: EndPoint) -> Observable<Data> {
        Observable.create { observer in
            do {
                let urlRequest = try endPoint.toURLRequest()
                let task = URLSession.shared.dataTask(
                    with: urlRequest
                ) { data, response, error in
                    if let error {
                        observer.onError(NetworkError.transportError(error))
                        return
                    }
                    guard let httpURLResponse = response as? HTTPURLResponse
                    else {
                        observer.onError(
                            NetworkError.invalidResponse
                        )
                        return
                    }
                    guard 200..<300 ~= httpURLResponse.statusCode
                    else {
                        observer.onError(
                            NetworkError.invalidStatusCode(
                                httpURLResponse.statusCode
                            )
                        )
                        return
                    }
                    guard let data
                    else {
                        observer.onError(NetworkError.invalidData)
                        return
                    }
                    observer.onNext(data)
                    observer.onCompleted()
                }
                task.resume()
                return Disposables.create {
                    task.cancel()
                }
            } catch {
                observer.onError(NetworkError.invalidURL)
                return Disposables.create()
            }
        }
    }
    
    public func request<T: Decodable>(
        endPoint: any EndPoint,
        responseType: T.Type
    ) -> Single<Result<T, Error>> {
        return Single.create { observer -> Disposable in
            guard let urlRequest = endPoint.toURLRequest
            else {
                observer(.success(.failure(NetworkError.invalidURL)))
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(
                with: urlRequest
            ) { data, response, error in
                if let error {
                    return observer(.success(
                        .failure(NetworkError.transportError(error))
                    ))
                }
                
                guard let httpURLResponse = response as? HTTPURLResponse
                else { return }
                guard 200..<300 ~= httpURLResponse.statusCode
                else {
                    return observer(.success(.failure(
                        NetworkError.invalidStatusCode(
                            httpURLResponse.statusCode
                        )
                    )))
                }
                
                guard let data 
                else { return observer(.success(
                    .failure(NetworkError.invalidData)
                ))}
                
                do {
                    let decoded = try JSONDecoder().decode(
                        responseType,
                        from: data
                    )
                    observer(.success(.success(decoded))) // 성공적으로 디코딩한 경우
                } catch {
                    observer(.success(.failure(NetworkError.parseError)))
                }
            }.resume()
            
            return Disposables.create()
        }
    }
}
