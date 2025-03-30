//
//  FirebaseSDK.swift
//  FirebaseModule
//
//  Created by Logan on 3/30/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Firebase
@_exported import FirebaseInterface

public final class FirebaseSDK {
    private static let proxy: MessagingDelegateProxy = .init()
    
    public static func configureFirebase(
        plistFilePath: String,
        application: UIApplication
    ) throws {
        guard let options = FirebaseOptions(contentsOfFile: plistFilePath) else {
            throw FirebaseSDKError.invalidFilePath
        }
        FirebaseApp.configure(options: options)
        application.registerForRemoteNotifications()
    }
    
    public static func didRegisterForRemoteNotificationsWithDeviceToken(
        deviceToken: Data
    ) async -> String? {
        Messaging.messaging().delegate = proxy
        Messaging.messaging().apnsToken = deviceToken
        return await proxy.requestFCMToken()
    }
    
    enum FirebaseSDKError: Error {
        case invalidFilePath, invalidFirebaseOption
    }
}
