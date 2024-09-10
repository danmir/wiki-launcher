import Foundation

final class ConsoleLogger: Logger {
    func log(_ message: String) {
        print(message)
    }
}
