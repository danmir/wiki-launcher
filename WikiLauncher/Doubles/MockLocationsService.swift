import Foundation

final class MockLocationsService: LocationsService {
    var fetchLocationsReturnValue: [LocationDTO] = []
    var fetchLocationsError: Error?

    func fetchLocations() async throws -> [LocationDTO] {
        if let error = fetchLocationsError {
            throw error
        }
        return fetchLocationsReturnValue
    }
}
