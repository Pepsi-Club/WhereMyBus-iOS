//
//  DefaultBusStopArrivalInfoRepository.swift
//  Data
//
//  Created by gnksbm on 1/25/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain
import Networks

import RxSwift

public final class DefaultBusStopArrivalInfoRepository
: NSObject, BusStopArrivalInfoRepository {
    private let networkService: NetworkService
    
    public let responses = BehaviorSubject<[RouteArrivalInfo]>(value: [])
    private let disposeBag = DisposeBag()
    
    private var key: String?
    private var value: String?
    private var xmlDic: [String: String]?
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func fetchArrivalList(
        busStopId: String,
        busStopName: String
    ) {
        networkService.request(
            endPoint: BusStopArrivalInfoEndPoint(busStopId: busStopId)
        )
        .withUnretained(self)
        .subscribe(
            onNext: { repository, data in
                let xmlParser = XMLParser(data: data)
                xmlParser.delegate = self
                xmlParser.parse()
            }
        )
        .disposed(by: disposeBag)
    }
}

extension DefaultBusStopArrivalInfoRepository: XMLParserDelegate {
    public func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String: String]
    ) {
        switch elementName {
        case "itemList":
            xmlDic = [:]
        case "busRouteAbrv":
            key = "busRouteAbrv"
        case "arrmsg1":
            key = "arrmsg1"
        case "arrmsg2":
            key = "arrmsg2"
        default:
            break
        }
    }
    
    public func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        switch elementName {
        case "stNm", "stId": // stationName, stationId
            break
        case "itemList":
            if let busRouteAbrv = xmlDic?["busRouteAbrv"],
               let arrmsg1 = xmlDic?["arrmsg1"],
               let arrmsg2 = xmlDic?["arrmsg2"] {
                let mss1Arr = arrmsg1.split(separator: "[").map { String($0) }
                let mss2Arr = arrmsg2.split(separator: "[").map { String($0) }
                var firstArrivalRemaining = ""
                var secondArrivalRemaining = ""
                if mss1Arr.count > 1 {
                    firstArrivalRemaining = mss1Arr[1]
                    firstArrivalRemaining.removeLast()
                }
                if mss2Arr.count > 1 {
                    secondArrivalRemaining = mss2Arr[1]
                    secondArrivalRemaining.removeLast()
                }
                let response = RouteArrivalInfo(
                    routeName: busRouteAbrv,
                    firstArrivalTime: mss1Arr[0],
                    firstArrivalRemaining: firstArrivalRemaining,
                    secondArrivalTime: mss2Arr[0],
                    secondArrivalRemaining: secondArrivalRemaining
                )
                do {
                    let value = try responses.value()
                    responses.onNext(value + [response])
                } catch {
                    responses.onError(error)
                }
            }
            xmlDic = nil
        case "busRouteAbrv":
            key = nil
        case "arrmsg1":
            key = nil
        case "arrmsg2":
            key = nil
        default:
            break
        }
    }
    
    public func parserDidEndDocument(_ parser: XMLParser) {
        let response = try? responses.value()
        responses.onCompleted()
    }
    
    public func parser(
        _ parser: XMLParser,
        foundCharacters string: String
    ) {
        guard xmlDic != nil,
              let key
        else { return }
        if key == "arrmsg1",
           let value = xmlDic?["arrmsg1"] {
            xmlDic?.updateValue(value + string, forKey: key)
            return
        }
        if key == "arrmsg2",
           let value = xmlDic?["arrmsg2"] {
            xmlDic?.updateValue(value + string, forKey: key)
            return
        }
        xmlDic?.updateValue(string, forKey: key)
    }
    
    public func parser(
        _ parser: XMLParser,
        parseErrorOccurred parseError: Error
    ) {
        responses.onError(parseError)
    }
}
