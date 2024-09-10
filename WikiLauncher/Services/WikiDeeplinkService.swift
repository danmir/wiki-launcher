import Foundation
import UIKit

enum WikiDeeplinkError: Error {
    case invalidDeeplink
}

protocol WikiDeeplinkService {
    func buildDeeplink(latitude: Double, longitude: Double) throws -> URL
    func buildAppStoreDeeplink() throws -> URL
    func isWikiInstalled() -> Bool
}

final class WikiDeeplinkServiceImpl: WikiDeeplinkService {
    enum Constant {
        static let wikiScheme = "wikipedia"
    }

    func buildDeeplink(latitude: Double, longitude: Double) throws -> URL {
        guard let url = URL(string: "\(Constant.wikiScheme)://places?lat=\(latitude)&long=\(longitude)") else {
            throw WikiDeeplinkError.invalidDeeplink
        }
        return url
    }

    func buildAppStoreDeeplink() throws -> URL {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/id324715238") else {
            throw WikiDeeplinkError.invalidDeeplink
        }
        return url
    }

    func isWikiInstalled() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "\(Constant.wikiScheme)://places")!)
    }
}
