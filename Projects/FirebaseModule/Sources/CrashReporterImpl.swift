import Foundation

import FirebaseCrashlytics

public final class CrashReporterImpl: CrashReporter {
    private let webhookURL: String?
    private let deviceModel: String
    private let osVersion: String
    private let appVersion: String

    private var lastReportTime: Date = .distantPast
    private let reportInterval: TimeInterval = 5

    public init(
        deviceModel: String,
        osVersion: String,
        appVersion: String
    ) {
        self.webhookURL = Bundle.main.infoDictionary?["DISCORD_WEBHOOK_URL"] as? String
        self.deviceModel = deviceModel
        self.osVersion = osVersion
        self.appVersion = appVersion
    }

    public func reportFatal(_ error: Error, file: String, line: Int) {
        record(error: error, file: file, line: line, isFatal: true)
    }

    public func reportNonFatal(_ error: Error, file: String, line: Int) {
        record(error: error, file: file, line: line, isFatal: false)
    }

    private func record(error: Error, file: String, line: Int, isFatal: Bool) {
        let crashlytics = Crashlytics.crashlytics()
        crashlytics.setCustomValue(file, forKey: "file")
        crashlytics.setCustomValue(line, forKey: "line")
        crashlytics.record(error: error)

        sendDiscordWebhook(error: error, file: file, line: line, isFatal: isFatal)
    }

    private func sendDiscordWebhook(
        error: Error,
        file: String,
        line: Int,
        isFatal: Bool
    ) {
        guard let webhookURL,
              !webhookURL.isEmpty,
              let url = URL(string: webhookURL)
        else { return }

        let now = Date()
        guard now.timeIntervalSince(lastReportTime) >= reportInterval else { return }
        lastReportTime = now

        let fileName = (file as NSString).lastPathComponent
        let severity = isFatal ? "Fatal" : "Non-Fatal"

        let embed: [String: Any] = [
            "title": "[\(severity)] \(fileName):\(line)",
            "description": String(error.localizedDescription.prefix(1024)),
            "color": isFatal ? 16711680 : 16744448,
            "fields": [
                ["name": "Device", "value": deviceModel, "inline": true],
                ["name": "OS", "value": "iOS \(osVersion)", "inline": true],
                ["name": "App Version", "value": appVersion, "inline": true],
            ]
        ]

        let body: [String: Any] = ["embeds": [embed]]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request).resume()
    }
}
