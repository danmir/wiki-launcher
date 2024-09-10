import Foundation
import UIKit

protocol ExternalDeeplinkRouter {
    func navigate(to url: URL)
}

final class ExternalDeeplinkRouterImpl: ExternalDeeplinkRouter {
    func navigate(to url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
