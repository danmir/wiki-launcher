import Foundation

enum ValidationError: Error, LocalizedError {
    case invalidCoordinates

    var errorDescription: String? {
        switch self {
        case .invalidCoordinates:
            return "Invalid coordinates. Please enter valid latitude and longitude values."
        }
    }
}

protocol CoordinatesValidator {
    func validate(latitude: String, longitude: String) -> Result<(Double, Double), ValidationError>
}

final class CoordinatesValidatorImpl: CoordinatesValidator {
    func validate(latitude: String, longitude: String) -> Result<(Double, Double), ValidationError> {
        guard let lat = Double(latitude), let lon = Double(longitude),
              lat >= -90 && lat <= 90, lon >= -180 && lon <= 180 else {
            return .failure(.invalidCoordinates)
        }
        return .success((lat, lon))
    }
}
