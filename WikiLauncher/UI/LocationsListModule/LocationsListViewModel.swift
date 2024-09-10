import Foundation
import SwiftUI

struct LocationItem: Identifiable, Equatable {
    var id: String
    var title: String
    var subtitle: String

    var model: LocationDTO
}

@MainActor
class LocationsListViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case loaded([LocationItem])
        case error(String)
    }

    @Published var state: State = .loading
    @Published var alertState: AlertState = .none

    private let locationsService: LocationsService
    private let wikiDeeplinkService: WikiDeeplinkService
    private let locationBuilder: LocationBuilder
    private let externalDeeplinkRouter: ExternalDeeplinkRouter
    private let logger: Logger

    private var tasks: [Task<Void, Never>] = []

    init(
        locationsService: LocationsService,
        wikiDeeplinkService: WikiDeeplinkService,
        locationBuilder: LocationBuilder,
        externalDeeplinkRouter: ExternalDeeplinkRouter,
        logger: Logger
    ) {
        self.locationsService = locationsService
        self.wikiDeeplinkService = wikiDeeplinkService
        self.locationBuilder = locationBuilder
        self.externalDeeplinkRouter = externalDeeplinkRouter
        self.logger = logger
    }

    func fetchLocations() {
        state = .loading

        let task = Task {
            do {
                state = .loading
                let locations = try await locationsService.fetchLocations()
                let builtLocations = locationBuilder.buildLocationItems(from: locations)
                state = .loaded(builtLocations)
            } catch {
                state = .error(error.localizedDescription)
            }
        }

        tasks.append(task)
    }

    func openMapApp(for location: LocationItem) {
        let deeplink: URL
        let appStoreDeeplink: URL
        do {
            deeplink = try wikiDeeplinkService.buildDeeplink(latitude: location.model.lat, longitude: location.model.long)
            appStoreDeeplink = try wikiDeeplinkService.buildAppStoreDeeplink()
        } catch {
            logger.log("LocationsListViewModel inconsistent buildDeeplink state")
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

    func cancelTasks() {
        tasks.forEach({ $0.cancel() })
        tasks = []
    }
}
