//
//  MessagingDelegateProxy.swift
//  FirebaseModule
//
//  Created by gnksbm on 3/30/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Firebase
import FirebaseMessaging

final class MessagingDelegateProxy: NSObject, MessagingDelegate {
    private var continuation: CheckedContinuation<String?, Never>?
    
    func requestFCMToken(deviceToken: Data) async -> String? {
        await withCheckedContinuation { continuation in
            Messaging.messaging().delegate = self
            Messaging.messaging().apnsToken = deviceToken
            self.continuation = continuation
        }
    }
    
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        continuation?.resume(returning: fcmToken)
        continuation = nil
    }
}
