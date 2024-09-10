import Foundation

final class MockWikiDeeplinkService: WikiDeeplinkService {
    var isWikiInstalledReturnValue: Bool = false
    var buildDeeplinkReturnValue: URL = URL(string: "https://wikipedia.org")!
    var buildAppStoreDeeplinkReturnValue: URL = URL(string: "https://appstore.com")!

    func isWikiInstalled() -> Bool {
        return isWikiInstalledReturnValue
    }

    func buildDeeplink(latitude: Double, longitude: Double) throws -> URL {
        return buildDeeplinkReturnValue
    }

    func buildAppStoreDeeplink() throws -> URL {
        return buildAppStoreDeeplinkReturnValue
    }
}
