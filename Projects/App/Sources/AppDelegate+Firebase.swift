//
//  AppDelegate+Firebase.swift
//  App
//
//  Created by gnksbm on 3/21/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import FirebaseModule

extension AppDelegate {
    func configureFirebase(application: UIApplication) {
        var googleInfoName: String
        #if DEBUG
        googleInfoName = "GoogleService-Info-debugging"
        #else
        googleInfoName = "GoogleService-Info"
        #endif
        let filePath = Bundle.main.path(forResource: "\(googleInfoName).plist", ofType: nil) ?? ""
        do {
            try FirebaseSDK.configureFirebase(plistFilePath: filePath, application: application)
        } catch {
            dump(error)
        }
    }
}

extension AppDelegate {
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Task {
            let fcmToken = await FirebaseSDK.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: deviceToken)
            guard let fcmToken else { return }
            UserDefaults.standard.setValue(
                fcmToken,
                forKey: "fcmToken"
            )
        }
    }
}
