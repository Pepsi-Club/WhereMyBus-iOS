//
//  DefaultLocalNotificationService.swift
//  Domain
//
//  Created by gnksbm on 2/27/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation
import UserNotifications

import Core
import Domain
import NetworkService

import RxSwift

public final class DefaultLocalNotificationService
: UNNotificationServiceExtension, LocalNotificationService {
    private let busStopArrivalInfoRepository: BusStopArrivalInfoRepository
    private let notificationCenter = UNUserNotificationCenter.current()
    
    public let authState = BehaviorSubject<UNAuthorizationStatus>(
        value: .denied
    )
    private let disposeBag = DisposeBag()

    public init(busStopArrivalInfoRepository: BusStopArrivalInfoRepository) {
        self.busStopArrivalInfoRepository = busStopArrivalInfoRepository
    }
    
    public override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler
        : @escaping (UNNotificationContent) -> Void
    ) {
        busStopArrivalInfoRepository.fetchArrivalList(
            busStopId: request.content.title
        )
        .subscribe(
            onNext: { response in
                guard let requestedBus = response.buses
                    .filter({ bus in
                        bus.busId == request.content.body
                    })
                    .first
                else { return }
                let title = "\(requestedBus.busName) 버스 도착 정보"
                let body = "\(requestedBus.firstArrivalTime) 도착 예정"
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                contentHandler(content)
            }
        )
        .disposed(by: disposeBag)
    }
    
    public func authorize() {
        notificationCenter.getNotificationSettings { [weak self] setting in
            self?.authState.onNext(setting.authorizationStatus)
            print(
                "settingStatus",
                String(describing: setting.authorizationStatus)
            )
        }
        authState
            .withUnretained(self)
            .subscribe(
                onNext: { notiService, state in
                    guard state != .authorized else { return }
                    notiService.notificationCenter.requestAuthorization(
                        options: [.alert, .sound, .badge]
                    ) { isAuthorized, error in
                        if let error {
                            notiService.authState.onError(error)
                        }
                        if isAuthorized {
                            notiService.authState.onNext(.authorized)
                        }
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    public func fetchRegularAlarm() {
        notificationCenter.getPendingNotificationRequests { requests in
            print(requests.map { $0.trigger })
        }
    }
    
    public func registNewRegularAlarm(response: RegularAlarmResponse) throws {
        let regularAlarm = response.weekDay.map { weekday in
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.weekday = weekday
            let dateStr = response.time
                .toString(dateFormat: "HH:mm")
                .split(separator: ":")
                .compactMap { Int($0) }
            dateComponents.hour = dateStr.first
            dateComponents.minute = dateStr.last
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: true
            )
            let content = UNMutableNotificationContent()
            content.title = "XX번 버스 도착정보"
            content.body = "메세지를 String으로 미리 입력해야 해서 로컬로 정보를 보낼 수 없음"
            content.userInfo = [
                AnyHashable("aps"): [
                    "content-available": 1
                ]
            ]
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger
            )
            return request
        }
        regularAlarm.forEach {
            notificationCenter.add($0)
        }
    }
    
    public func editRegularAlarm() throws {
        
    }
    
    public func deleteRegularAlarm() throws {
        
    }
}
