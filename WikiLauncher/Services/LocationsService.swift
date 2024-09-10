import Foundation

struct LocationDTO: Decodable, Equatable {
    let name: String?
    let lat: Double
    let long: Double
}

struct LocationsDTO: Decodable {
    let locations: [LocationDTO]
}

protocol LocationsService {
    func fetchLocations() async throws -> [LocationDTO]
}

final class LocationsServiceImpl: LocationsService  {
    private let requestSender: RequestSender
    private let responseParser: ResponseParser

    init(requestSender: RequestSender, responseParser: ResponseParser) {
        self.requestSender = requestSender
        self.responseParser = responseParser
    }

    func fetchLocations() async throws -> [LocationDTO] {
        let url = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!
        let request = HTTPRequest(url: url, method: "GET", headers: nil, body: nil)

        let response = try await requestSender.sendRequest(request)
        let locationsResponse = try responseParser.parseResponse(response.data, as: LocationsDTO.self)

        return locationsResponse.locations
    }
}
