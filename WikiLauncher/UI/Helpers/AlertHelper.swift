import SwiftUI

struct AlertHelper {
    static func createAlert(for state: AlertState) -> Alert {
        switch state {
        case .singleButton(let title, let message, let buttonText, let action):
            return Alert(
                title: Text(title),
                message: Text(message),
                dismissButton: .default(Text(buttonText), action: action)
            )
        case .doubleButton(let title, let message, let primaryButtonText, let secondaryButtonText, let primaryAction, let secondaryAction):
            return Alert(
                title: Text(title),
                message: Text(message),
                primaryButton: .default(Text(primaryButtonText), action: primaryAction),
                secondaryButton: .cancel(Text(secondaryButtonText), action: secondaryAction)
            )
        case .none:
            return Alert(title: Text("Unknown Error"))
        }
    }
}