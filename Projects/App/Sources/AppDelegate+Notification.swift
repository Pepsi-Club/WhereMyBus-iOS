//
//  AppDelegate+Notification.swift
//  App
//
//  Created by gnksbm on 2/27/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit
import UserNotifications

import Firebase
import FirebaseMessaging

extension AppDelegate {
    func configureNotification(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
//        guard let filePath = Bundle.main.path(
//            forResource: "GoogleService-Info",
//            ofType: "plist"
//        ),
//              let options = FirebaseOptions(contentsOfFile: filePath)
//        else { return }
//        FirebaseApp.configure(options: options)
//        application.registerForRemoteNotifications()
//        Messaging.messaging().delegate = self
    }
}
// MARK: Remote
extension AppDelegate {
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (
            UNNotificationPresentationOptions
        ) -> Void
    ) {
        completionHandler([.banner, .badge, .sound, .list])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        guard let fcmToken else { return }
        UserDefaults.standard.setValue(
            fcmToken,
            forKey: "fcmToken"
        )
    }
}
