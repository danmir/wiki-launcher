import Foundation

enum AlertState: Equatable, Identifiable {
    var id: UUID {
        switch self {
        case .none:
            return UUID()
        case .singleButton(let title, let message, let buttonText, _):
            return UUID(uuidString: "\(title)-\(message)-\(buttonText)".hashValue.description)!
        case .doubleButton(let title, let message, let primaryButtonText, let secondaryButtonText, _, _):
            return UUID(uuidString: "\(title)-\(message)-\(primaryButtonText)-\(secondaryButtonText)".hashValue.description)!
        }
    }

    case none
    case singleButton(
        title: String,
        message: String,
        buttonText: String,
        action: (() -> Void)? = nil
    )
    case doubleButton(
        title: String,
        message: String,
        primaryButtonText: String,
        secondaryButtonText: String,
        primaryAction: (() -> Void)? = nil,
        secondaryAction: (() -> Void)? = nil
    )

    static func == (lhs: AlertState, rhs: AlertState) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.singleButton(let lhsTitle, let lhsMessage, let lhsButtonText, _),
              .singleButton(let rhsTitle, let rhsMessage, let rhsButtonText, _)):
            return lhsTitle == rhsTitle && lhsMessage == rhsMessage && lhsButtonText == rhsButtonText
        case (.doubleButton(let lhsTitle, let lhsMessage, let lhsPrimary, let lhsSecondary, _, _),
              .doubleButton(let rhsTitle, let rhsMessage, let rhsPrimary, let rhsSecondary, _, _)):
            return lhsTitle == rhsTitle && lhsMessage == rhsMessage && lhsPrimary == rhsPrimary && lhsSecondary == rhsSecondary
        default:
            return false
        }
    }
}
