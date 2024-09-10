import Foundation

final class MockCoordinatesValidator: CoordinatesValidator {
    var validateReturnValue: Result<(Double, Double), ValidationError> = .failure(ValidationError.invalidCoordinates)

    func validate(latitude: String, longitude: String) -> Result<(Double, Double), ValidationError> {
        return validateReturnValue
    }
}
