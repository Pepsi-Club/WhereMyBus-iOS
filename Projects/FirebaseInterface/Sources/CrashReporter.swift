import Foundation

public protocol CrashReporter {
    func reportFatal(_ error: Error, file: String, line: Int)
    func reportNonFatal(_ error: Error, file: String, line: Int)
}

public extension CrashReporter {
    func recordFatal(
        _ error: Error,
        file: String = #file,
        line: Int = #line
    ) {
        reportFatal(error, file: file, line: line)
    }

    func recordNonFatal(
        _ error: Error,
        file: String = #file,
        line: Int = #line
    ) {
        reportNonFatal(error, file: file, line: line)
    }
}
