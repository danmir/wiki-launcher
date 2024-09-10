import XCTest
@testable import WikiLauncher

class CustomCoordinatesViewModelTests: XCTestCase {
    var viewModel: CustomCoordinatesViewModel!
    var mockWikiDeeplinkService: MockWikiDeeplinkService!
    var mockCoordinatesValidator: MockCoordinatesValidator!
    var mockExternalDeeplinkRouter: MockExternalDeeplinkRouter!
    var mockLogger: MockLogger!

    @MainActor 
    override func setUp() {
        super.setUp()
        mockWikiDeeplinkService = MockWikiDeeplinkService()
        mockCoordinatesValidator = MockCoordinatesValidator()
        mockExternalDeeplinkRouter = MockExternalDeeplinkRouter()
        mockLogger = MockLogger()
        viewModel = CustomCoordinatesViewModel(
            wikiDeeplinkService: mockWikiDeeplinkService,
            coordinatesValidator: mockCoordinatesValidator,
            externalDeeplinkRouter: mockExternalDeeplinkRouter,
            logger: mockLogger
        )
    }

    override func tearDown() {
        viewModel = nil
        mockWikiDeeplinkService = nil
        mockCoordinatesValidator = nil
        mockExternalDeeplinkRouter = nil
        mockLogger = nil
        super.tearDown()
    }

    @MainActor 
    func testValidateAndOpenMap_WithInvalidCoordinates_ShowsAlert() {
        mockCoordinatesValidator.validateReturnValue = .failure(ValidationError.invalidCoordinates)

        viewModel.validateAndOpenMap(latitude: "invalid", longitude: "invalid")

        XCTAssertEqual(viewModel.alertState, .singleButton(
            title: "Invalid input",
            message: ValidationError.invalidCoordinates.localizedDescription,
            buttonText: "OK",
            action: { }
        ))
    }

    @MainActor
    func testValidateAndOpenMap_WithValidCoordinates_WhenWikiNotInstalled_ShowsAppStoreAlert() {
        mockCoordinatesValidator.validateReturnValue = .success((10.10, -10.10))
        mockWikiDeeplinkService.isWikiInstalledReturnValue = false

        viewModel.validateAndOpenMap(latitude: "10.10", longitude: "-10.10")

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
    func testValidateAndOpenMap_WithValidCoordinates_WhenWikiInstalled_NavigatesToWiki() {
        mockCoordinatesValidator.validateReturnValue = .success((10.10, -10.10))
        mockWikiDeeplinkService.isWikiInstalledReturnValue = true

        viewModel.validateAndOpenMap(latitude: "10.10", longitude: "-10.10")

        XCTAssertEqual(mockExternalDeeplinkRouter.lastNavigatedURL, mockWikiDeeplinkService.buildDeeplinkReturnValue)
    }
}
