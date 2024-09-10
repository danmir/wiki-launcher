import Foundation

final class MockLocationBuilder: LocationBuilder {
    var buildLocationItemsReturnValue: [LocationItem] = []

    func buildLocationItems(from locations: [LocationDTO]) -> [LocationItem] {
        return buildLocationItemsReturnValue
    }
}
