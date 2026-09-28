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
    
    /// - Parameter onUserIDRegistered: Crashlytics User ID 등록이 끝난 뒤 메인 스레드에서 호출
    public static func configureFirebase(
        plistFilePath: String,
        application: UIApplication,
        onUserIDRegistered: (() -> Void)? = nil
    ) throws {
        guard let options = FirebaseOptions(contentsOfFile: plistFilePath) else {
            throw FirebaseSDKError.invalidFilePath
        }
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure(options: options)
        registerCrashlyticsUserID(completion: onUserIDRegistered)
        application.registerForRemoteNotifications()
    }
    
    /// Crashlytics 콘솔에서 User ID로 기기별 이벤트를 검색할 수 있도록 등록한다.
    private static func registerCrashlyticsUserID(completion: (() -> Void)?) {
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
            if let completion {
                DispatchQueue.main.async(execute: completion)
            }
        }
    }
    
    public static func didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: Data) async -> String? {
        await proxy.requestFCMToken(deviceToken: deviceToken)
    }
    
    enum FirebaseSDKError: Error {
        case invalidFilePath, invalidFirebaseOption
    }
}
