//
//  AppDelegate+Firebase.swift
//  App
//
//  Created by gnksbm on 3/21/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core
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
            try FirebaseSDK.configureFirebase(
                plistFilePath: filePath,
                application: application
            )
            registerCrashReporterUserID()
        } catch {
            #if DEBUG
            print("⚠️ Firebase 초기화 실패: \(error.localizedDescription)")
            #endif
        }
    }
}

extension AppDelegate {
    /// Crashlytics 콘솔에서 User ID(Installation ID)로 기기별 이벤트를 검색할 수 있도록 등록
    private func registerCrashReporterUserID() {
        Task {
            guard let installationID = await FirebaseSDK.installationID() else { return }
            @Injected var crashReporter: CrashReporter
            crashReporter.setUserID(installationID)
            #if DEBUG
            sendCrashReporterTestIfNeeded()
            #endif
        }
    }

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

#if DEBUG
extension AppDelegate {
    /// 스킴 Arguments에 `-CrashReporterTest`를 넣고 실행하면 Crashlytics / Discord로 테스트 이벤트를 보낸다.
    /// Crashlytics User ID 등록이 끝난 뒤 호출된다.
    func sendCrashReporterTestIfNeeded() {
        guard ProcessInfo.processInfo.arguments.contains("-CrashReporterTest")
        else { return }
        @Injected var crashReporter: CrashReporter
        crashReporter.recordNonFatal(
            NSError(
                domain: "CrashReporterTest",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "CrashReporter 연동 테스트"]
            )
        )
        print("✅ CrashReporter 테스트 이벤트 기록")
    }
}
#endif
