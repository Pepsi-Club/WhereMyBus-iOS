//
//  NotificationService.swift
//  NotificationExtension
//
//  Created by gnksbm on 3/2/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UserNotifications

import Domain
import Data

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler
        : @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        bestAttemptContent = (
            request.content.mutableCopy() as? UNMutableNotificationContent
        )
        guard let bestAttemptContent else { return }
        bestAttemptContent.title = "Mutable 도착"
        let body = bestAttemptContent.userInfo
            .map { key, value in
                "\(String(describing: key)): \(String(describing: value))"
            }
            .joined()
        bestAttemptContent.body = body
        
        guard let aps = bestAttemptContent.userInfo["aps"] as? [String: Any],
              let urlStr = aps["urlStr"] as? String
        else {
            bestAttemptContent.title = "urlStr 없음"
            contentHandler(bestAttemptContent)
            return
        }
        bestAttemptContent.title = "urlStr 있음"
        guard let url = URL(string: urlStr)
        else {
            bestAttemptContent.title = "잘못된 url"
            contentHandler(bestAttemptContent)
            return
        }
        bestAttemptContent.title = "url 변환까지 성공"
        do {
            let arrivalInfo = try Data(contentsOf: url).decode(
                type: BusStopArrivalInfoResponse.self
            )
            let title = "네트워킹 성공"
            let body = "네트워킹 성공"
            bestAttemptContent.title = title
            bestAttemptContent.body = body     
        } catch {
            let title = "네트워킹 실패"
            let body = "네트워킹 실패"
            bestAttemptContent.title = title
            bestAttemptContent.body = body
        }
        contentHandler(bestAttemptContent)
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler,
           let bestAttemptContent = bestAttemptContent {
            bestAttemptContent.title = "제한시간 초과"
            contentHandler(bestAttemptContent)
        }
    }
}
