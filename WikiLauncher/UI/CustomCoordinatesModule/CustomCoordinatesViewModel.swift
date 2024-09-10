import Foundation

@MainActor
class CustomCoordinatesViewModel: ObservableObject {
    private let wikiDeeplinkService: WikiDeeplinkService
    private let coordinatesValidator: CoordinatesValidator
    private let externalDeeplinkRouter: ExternalDeeplinkRouter
    private let logger: Logger

    @Published var alertState: AlertState = .none

    init(
        wikiDeeplinkService: WikiDeeplinkService,
        coordinatesValidator: CoordinatesValidator,
        externalDeeplinkRouter: ExternalDeeplinkRouter,
        logger: Logger
    ) {
        self.wikiDeeplinkService = wikiDeeplinkService
        self.coordinatesValidator = coordinatesValidator
        self.externalDeeplinkRouter = externalDeeplinkRouter
        self.logger = logger
    }

    func validateAndOpenMap(latitude: String, longitude: String) {
        switch coordinatesValidator.validate(latitude: latitude, longitude: longitude) {
        case .success(let coords):
            alertState = .none
            openMapApp(withLatitude: coords.0, longitude: coords.1)
        case .failure(let error):
            alertState = .singleButton(
                title: "Invalid input",
                message: error.localizedDescription,
                buttonText: "OK",
                action: { [weak self] in self?.alertState = .none }
            )
        }
    }

    private func openMapApp(withLatitude latitude: Double, longitude: Double) {
        let deeplink: URL
        let appStoreDeeplink: URL
        do {
            deeplink = try wikiDeeplinkService.buildDeeplink(latitude: latitude, longitude: longitude)
            appStoreDeeplink = try wikiDeeplinkService.buildAppStoreDeeplink()
        } catch {
            logger.log("CustomCoordinatesViewModel inconsistent buildDeeplink state")
            return
        }

        if (!wikiDeeplinkService.isWikiInstalled()) {
            alertState = .doubleButton(
                title: "Wiki is not Installed",
                message: "Would you like to go to the App Store to install it?",
                primaryButtonText: "Go to App Store",
                secondaryButtonText: "Cancel",
                primaryAction: { [weak self] in self?.externalDeeplinkRouter.navigate(to: appStoreDeeplink) },
                secondaryAction: { [weak self] in self?.alertState = .none }
            )
            return
        }

        externalDeeplinkRouter.navigate(to: deeplink)
    }
}
