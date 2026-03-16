import Foundation
import Core

public struct GithubFileDownloadEndPoint: EndPoint {
    private let owner = "Pepsi-Club"
    private let branch = "main"
    private let repo: String
    private let filePath: String

    public init(repo: String, filePath: String) {
        self.repo = repo
        self.filePath = filePath
    }

    public var scheme: Scheme { .https }
    public var host: String { "raw.githubusercontent.com" }
    public var port: String { "" }
    public var path: String { "/\(owner)/\(repo)/\(branch)/\(filePath)" }
    public var query: [String: String] { [:] }
    public var body: [String: Any] { [:] }
    public var method: HTTPMethod { .get }
    public var header: [String: String] {
        ["Authorization": "token \(String.githubAccessToken)"]
    }
}
