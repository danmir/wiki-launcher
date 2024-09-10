import Foundation

enum NetworkError: Error {
    case parsingError(Error)
    case unknownError
}
