//
//  NewDefaultBusStopArrivalInfoRepository.swift
//  Data
//
//  Created by gnksbm on 1/30/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain
import Networks

import RxSwift
import SwiftyXMLParser

public final class NewDefaultBusStopArrivalInfoRepository:
    NSObject, NewBusStopArrivalInfoRepository {
    private let networkService: NetworkService
    
    private let busResponses = BehaviorSubject<[BusArrivalInfoResponse]>(
        value: []
    )
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
    ) -> Observable<BusStopArrivalInfoResponse> {
        networkService.request(
            endPoint: BusStopArrivalInfoEndPoint(busStopId: busStopId)
        )
        .map { data in
            let xml = XML.parse(data)
            let busResponses: [BusArrivalInfoResponse] = xml
                .ServiceResult
                .msgBody
                .itemList
                .compactMap {
                    guard let routeId = $0.busRouteId.text,
                          let routeName = $0.busRouteAbrv.text,
                          let busType = $0.routeType.text,
                          let firstArrivalTime = $0.arrmsg1.text,
                          let secondArrivalTime = $0.arrmsg2.text
                    else { return nil }
                    return BusArrivalInfoResponse(
                        routeId: routeId,
                        isFavorites: false,
                        routeName: routeName,
                        busType: busType,
                        firstArrivalTime: firstArrivalTime,
                        secondArrivalTime: secondArrivalTime,
                        isAlarmOn: false
                    )
                }
            return BusStopArrivalInfoResponse(
                busStopId: busStopId,
                busStopName: busStopName,
                direction: "XX 방면",
                buses: busResponses.compactMap { $0 }
            )
        }
    }
}

extension NewDefaultBusStopArrivalInfoRepository: XMLParserDelegate {
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
        case "busRouteAbrv", "busRouteId", "routeType", "arrmsg1", "arrmsg2":
            key = elementName
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
        case "itemList":
            if let busRouteAbrv = xmlDic?["busRouteAbrv"],
               let busRouteId = xmlDic?["busRouteId"],
               let routeType = xmlDic?["routeType"],
               let arrmsg1 = xmlDic?["arrmsg1"],
               let arrmsg2 = xmlDic?["arrmsg2"] {
                let response = BusArrivalInfoResponse(
                    routeId: busRouteId,
                    isFavorites: false,
                    routeName: busRouteAbrv,
                    busType: routeType,
                    firstArrivalTime: arrmsg1,
                    secondArrivalTime: arrmsg2,
                    isAlarmOn: false
                )
                do {
                    let value = try busResponses.value()
                    busResponses.onNext(value + [response])
                } catch {
                    busResponses.onError(error)
                }
            }
            xmlDic = nil
        case "busRouteAbrv", "busRouteId", "routeType", "arrmsg1", "arrmsg2":
            key = nil
        default:
            break
        }
    }
    
    public func parserDidEndDocument(_ parser: XMLParser) {
        busResponses.onCompleted()
    }
    
    public func parser(
        _ parser: XMLParser,
        foundCharacters string: String
    ) {
        guard xmlDic != nil,
              let key
        else { return }
        // arrmsg의 분표시가 (시간, 분 xx초[x정거장 전])으로 2번에 나누어 들어와 예외처리
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
        busResponses.onError(parseError)
    }
}
