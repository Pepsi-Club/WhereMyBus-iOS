import Foundation

import FirebaseCore
import FirebaseCrashlytics
import FirebaseInterface

public final class CrashReporterImpl: CrashReporter {
    private let webhookURL: URL?
    private let deviceModel: String
    private let osVersion: String
    private let appVersion: String

    private var lastReportTime: Date = .distantPast
    private let reportInterval: TimeInterval = 5
    private var userID: String?

    /// 현재 빌드가 사용하는 Firebase 프로젝트의 Crashlytics 이슈 목록 URL
    /// (FirebaseApp.configure 이후에 접근되도록 lazy)
    private lazy var crashlyticsConsoleURL: String? = {
        guard let projectID = FirebaseApp.app()?.options.projectID,
              let bundleID = Bundle.main.bundleIdentifier
        else { return nil }
        return "https://console.firebase.google.com/project/\(projectID)"
        + "/crashlytics/app/ios:\(bundleID)/issues"
    }()

    public init(
        deviceModel: String,
        osVersion: String,
        appVersion: String
    ) {
        self.webhookURL = Self.validatedWebhookURL(
            Bundle.main.infoDictionary?["DISCORD_WEBHOOK_URL"] as? String
        )
        self.deviceModel = deviceModel
        self.osVersion = osVersion
        self.appVersion = appVersion
    }

    public func setUserID(_ userID: String) {
        self.userID = userID
        Crashlytics.crashlytics().setUserID(userID)
    }

    public func reportFatal(_ error: Error, file: String, line: Int) {
        record(error: error, file: file, line: line, isFatal: true)
    }

    public func reportNonFatal(_ error: Error, file: String, line: Int) {
        record(error: error, file: file, line: line, isFatal: false)
    }

    private func record(error: Error, file: String, line: Int, isFatal: Bool) {
        let fileName = (file as NSString).lastPathComponent
        let userInfo: [String: Any] = [
            "file": fileName,
            "line": line
        ]
        let nsError = NSError(
            domain: (error as NSError).domain,
            code: (error as NSError).code,
            userInfo: (error as NSError).userInfo.merging(userInfo) { _, new in new }
        )
        Crashlytics.crashlytics().record(error: nsError)

        sendDiscordWebhook(error: error, file: file, line: line, isFatal: isFatal)
    }

    private func sendDiscordWebhook(
        error: Error,
        file: String,
        line: Int,
        isFatal: Bool
    ) {
        guard let webhookURL else { return }

        let now = Date()
        guard now.timeIntervalSince(lastReportTime) >= reportInterval else { return }
        lastReportTime = now

        let fileName = (file as NSString).lastPathComponent
        let severity = isFatal ? "Fatal" : "Non-Fatal"

        var embed: [String: Any] = [
            "title": "[\(severity)] \(fileName):\(line)",
            "description": String(error.localizedDescription.prefix(1024)),
            "color": isFatal ? 16711680 : 16744448,
            "fields": [
                ["name": "Device", "value": deviceModel, "inline": true],
                ["name": "OS", "value": "iOS \(osVersion)", "inline": true],
                ["name": "App Version", "value": appVersion, "inline": true],
                [
                    "name": "User ID",
                    "value": userID ?? "-",
                    "inline": false
                ],
            ]
        ]
        if let consoleURL = crashlyticsConsoleURL {
            embed["url"] = consoleURL
        }

        let body: [String: Any] = ["embeds": [embed]]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else { return }

        var request = URLRequest(url: webhookURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { _, response, error in
            #if DEBUG
            if let error {
                print("⚠️ Discord webhook 전송 실패: \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse,
                      !(200..<300 ~= httpResponse.statusCode) {
                print("⚠️ Discord webhook 전송 실패: status \(httpResponse.statusCode)")
            }
            #endif
        }.resume()
    }

    private static func validatedWebhookURL(_ string: String?) -> URL? {
        guard let string,
              let url = URL(string: string),
              url.scheme?.lowercased() == "https",
              url.host != nil
        else {
            #if DEBUG
            print("⚠️ Discord webhook URL이 올바르지 않습니다 (누락 또는 https 아님)")
            #endif
            return nil
        }
        return url
    }
}
