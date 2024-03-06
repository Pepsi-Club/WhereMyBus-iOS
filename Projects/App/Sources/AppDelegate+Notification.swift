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

extension AppDelegate: UNUserNotificationCenterDelegate {
    func configureNotification(application: UIApplication) {
        guard let filePath = Bundle.main.path(
            forResource: "GoogleService-Info", 
            ofType: "plist"
        ),
              let options = FirebaseOptions(contentsOfFile: filePath)
        else { return }
        
        FirebaseApp.configure(options: options)
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (
            UNNotificationPresentationOptions
        ) -> Void
    ) {
        completionHandler([.banner, .badge, .sound])
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
