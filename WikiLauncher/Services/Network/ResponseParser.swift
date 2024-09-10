import Foundation

protocol ResponseParser {
    func parseResponse<T: Decodable>(_ data: Data, as type: T.Type) throws -> T
}

final class ResponseParserImpl: ResponseParser {
    private let logger: Logger

    init(logger: Logger) {
        self.logger = logger
    }

    func parseResponse<T: Decodable>(_ data: Data, as type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch let decodingError {
            logger.log("Failed to parse response: \(decodingError)")
            throw NetworkError.parsingError(decodingError)
        }
    }
}
