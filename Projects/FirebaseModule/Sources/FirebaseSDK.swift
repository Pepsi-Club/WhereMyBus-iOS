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
    /// Crashlytics User ID로 등록된 Firebase Installation ID
    public private(set) static var installationID: String?
    
    public static func configureFirebase(
        plistFilePath: String,
        application: UIApplication
    ) throws {
        guard let options = FirebaseOptions(contentsOfFile: plistFilePath) else {
            throw FirebaseSDKError.invalidFilePath
        }
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure(options: options)
        registerCrashlyticsUserID()
        application.registerForRemoteNotifications()
    }
    
    /// Crashlytics 콘솔에서 User ID로 기기별 이벤트를 검색할 수 있도록 등록한다.
    private static func registerCrashlyticsUserID() {
        Installations.installations().installationID { fetchedID, error in
            guard let fetchedID else {
                #if DEBUG
                let reason = error?.localizedDescription ?? "unknown"
                print("⚠️ Installation ID 조회 실패: \(reason)")
                #endif
                return
            }
            installationID = fetchedID
            Crashlytics.crashlytics().setUserID(fetchedID)
        }
    }
    
    public static func didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: Data) async -> String? {
        await proxy.requestFCMToken(deviceToken: deviceToken)
    }
    
    enum FirebaseSDKError: Error {
        case invalidFilePath, invalidFirebaseOption
    }
}
