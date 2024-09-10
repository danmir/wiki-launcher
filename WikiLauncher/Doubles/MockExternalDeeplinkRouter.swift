import Foundation

final class MockExternalDeeplinkRouter: ExternalDeeplinkRouter {
    var lastNavigatedURL: URL?

    func navigate(to deeplink: URL) {
        lastNavigatedURL = deeplink
    }
}
