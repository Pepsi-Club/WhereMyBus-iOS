//
//  NotificationService.swift
//  NotificationExtension
//
//  Created by gnksbm on 3/2/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UserNotifications

import Data
import Domain
import NetworkService

import RxSwift

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    private let repository = DefaultBusStopArrivalInfoRepository(
        networkService: DefaultNetworkService()
    )
    private let disposeBag = DisposeBag()
    
    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler
        : @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        bestAttemptContent = (
            request.content.mutableCopy() as? UNMutableNotificationContent
        )
        guard let userInfo = bestAttemptContent?.userInfo,
              let busStopId = userInfo["busStopId"] as? String,
              let busId = userInfo["busId"] as? String,
              let bestAttemptContent
        else { return }
        repository.fetchArrivalList(busStopId: busStopId)
            .subscribe(
                onNext: { response in
                    guard let bus = response.buses.first(
                        where: { busResponse in
                            busResponse.busId == busId
                        }
                    )
                    else { return }
                    let busStopName = response.busStopName
                    let firstArrivalTime = bus.firstArrivalState.toString
                    let secondArrivalTime = bus.secondArrivalState.toString
                    let routeMessage: String
                    let remainingMessage: String
                    let firstLine: String
                    var secondLine: String
                    switch secondArrivalTime {
                    case "곧 도착":
                        secondLine = "다음 버스는 곧 도착해요."
                    case "운행종료":
                        secondLine = "다음 버스는 운행이 종료되었어요."
                    case "출발대기":
                        secondLine = "다음 버스는 출발 대기 중이에요."
                    default:
                        secondLine = "다음 버스는 \(secondArrivalTime)에 도착해요."
                    }
                    switch bus.firstArrivalState.toString {
                    case "곧 도착":
                        routeMessage = "\(bus.busName)번 버스가 \(busStopName)에"
                        remainingMessage = "곧 도착해요."
                    case "운행종료":
                        routeMessage = "\(bus.busName)번 버스는"
                        remainingMessage = "운행이 종료 되었어요."
                        secondLine = ""
                    case "출발대기":
                        routeMessage = "\(bus.busName)번 버스는"
                        remainingMessage = "출발 대기 중 이에요."
                        secondLine = ""
                    default:
                        routeMessage = "\(bus.busName)번 버스가 \(busStopName)에"
                        remainingMessage = "\(firstArrivalTime)에 도착해요."
                    }
                    firstLine = "\(routeMessage) \(remainingMessage)"
                    let body = [firstLine, secondLine].joined(separator: " ")
                    if let appName = Bundle.main.object(
                        forInfoDictionaryKey: "CFBundleDisplayName"
                    ) as? String {
                        bestAttemptContent.title = appName
                    }
                    bestAttemptContent.subtitle = ""
                    bestAttemptContent.body = body
                    contentHandler(bestAttemptContent)
                }
            )
            .disposed(by: disposeBag)
    }
    
    override func serviceExtensionTimeWillExpire() {
    }
}
