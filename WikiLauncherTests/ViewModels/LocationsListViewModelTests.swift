import XCTest
import Combine
@testable import WikiLauncher

class LocationsListViewModelTests: XCTestCase {
    enum MockFetchError: LocalizedError {
        case someError

        var errorDescription: String? {
            return "Some error occurred"
        }
    }

    var viewModel: LocationsListViewModel!
    var mockLocationsService: MockLocationsService!
    var mockWikiDeeplinkService: MockWikiDeeplinkService!
    var mockLocationBuilder: MockLocationBuilder!
    var mockExternalDeeplinkRouter: MockExternalDeeplinkRouter!
    var mockLogger: MockLogger!
    var cancellables: Set<AnyCancellable>!

    @MainActor 
    override func setUp() {
        super.setUp()
        mockLocationsService = MockLocationsService()
        mockWikiDeeplinkService = MockWikiDeeplinkService()
        mockLocationBuilder = MockLocationBuilder()
        mockExternalDeeplinkRouter = MockExternalDeeplinkRouter()
        mockLogger = MockLogger()

        viewModel = LocationsListViewModel(
            locationsService: mockLocationsService,
            wikiDeeplinkService: mockWikiDeeplinkService,
            locationBuilder: mockLocationBuilder,
            externalDeeplinkRouter: mockExternalDeeplinkRouter,
            logger: mockLogger
        )

        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        mockLocationsService = nil
        mockWikiDeeplinkService = nil
        mockLocationBuilder = nil
        mockExternalDeeplinkRouter = nil
        mockLogger = nil
        cancellables = nil
        super.tearDown()
    }

    @MainActor
    func testFetchLocations_SuccessfulFetch_ShouldUpdateStateToLoaded() {
        let mockLocations = [LocationDTO(name: "name", lat: 37.7749, long: -122.4194)]
        let mockLocationItems = [LocationItem(id: "1", title: "Location 1", subtitle: "Sub 1", model: mockLocations[0])]

        mockLocationsService.fetchLocationsReturnValue = mockLocations
        mockLocationBuilder.buildLocationItemsReturnValue = mockLocationItems

        let expectation = XCTestExpectation(description: "State should update to .loaded")

        viewModel.$state.eraseToAnyPublisher()
            .sink { state in
                if case .loaded(let locations) = state {
                    XCTAssertEqual(locations, mockLocationItems)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchLocations()

        wait(for: [expectation], timeout: 1.0)
    }

    @MainActor
    func testFetchLocations_FailedFetch_ShouldUpdateStateToError() {
        let fetchError = MockFetchError.someError
        mockLocationsService.fetchLocationsError = fetchError

        let expectation = XCTestExpectation(description: "State should update to .error")

        viewModel.$state.eraseToAnyPublisher()
            .sink { state in
                if case .error(let error) = state {
                    XCTAssertEqual(error, fetchError.localizedDescription)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.fetchLocations()

        wait(for: [expectation], timeout: 1.0)
    }

    @MainActor
    func testOpenMapApp_WikiNotInstalled_ShouldShowAppStoreAlert() {
        let locationItem = LocationItem(
            id: "1",
            title: "Location 1",
            subtitle: "Sub 1",
            model: LocationDTO(name: "Location 1", lat: 37.7749, long: -122.4194)
        )
        mockWikiDeeplinkService.isWikiInstalledReturnValue = false

        viewModel.openMapApp(for: locationItem)

        XCTAssertEqual(viewModel.alertState, .doubleButton(
            title: "Wiki is not Installed",
            message: "Would you like to go to the App Store to install it?",
            primaryButtonText: "Go to App Store",
            secondaryButtonText: "Cancel",
            primaryAction: { },
            secondaryAction: { }
        ))
    }

    @MainActor
    func testOpenMapApp_WikiInstalled_ShouldNavigateToWiki() {
        let locationItem = LocationItem(
            id: "1",
            title: "Location 1",
            subtitle: "Sub 1",
            model: LocationDTO(name: "Location 1", lat: 37.7749, long: -122.4194)
        )
        mockWikiDeeplinkService.isWikiInstalledReturnValue = true

        viewModel.openMapApp(for: locationItem)

        XCTAssertEqual(mockExternalDeeplinkRouter.lastNavigatedURL, mockWikiDeeplinkService.buildDeeplinkReturnValue)
    }
}
