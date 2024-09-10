import Foundation

final class MockLogger: Logger {
    var lastLoggedMessage: String?

    func log(_ message: String) {
        lastLoggedMessage = message
    }
}
