import Foundation

class MainViewModel: ObservableObject {
    let diContainer: DIContainer

    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }

    @MainActor 
    func makeLocationsListViewModel() -> LocationsListViewModel {
        return LocationsListViewModel(
            locationsService: diContainer.locationsService,
            wikiDeeplinkService: diContainer.wikiDeeplinkService,
            locationBuilder: diContainer.locationBuilder,
            externalDeeplinkRouter: diContainer.externalDeeplinkRouter,
            logger: diContainer.logger
        )
    }

    @MainActor 
    func makeCustomCoordinatesViewModel() -> CustomCoordinatesViewModel {
        return CustomCoordinatesViewModel(
            wikiDeeplinkService: diContainer.wikiDeeplinkService,
            coordinatesValidator: diContainer.coordinatesValidator,
            externalDeeplinkRouter: diContainer.externalDeeplinkRouter,
            logger: diContainer.logger
        )
    }
}
