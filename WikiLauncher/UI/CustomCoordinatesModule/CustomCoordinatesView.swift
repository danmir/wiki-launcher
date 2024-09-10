import SwiftUI

struct CustomCoordinatesView: View {
    @StateObject private var viewModel: CustomCoordinatesViewModel

    @State private var latitude: String = ""
    @State private var longitude: String = ""

    init(viewModel: CustomCoordinatesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Coordinates")) {
                    TextField("Latitude", text: $latitude)
                        .keyboardType(.decimalPad)
                    TextField("Longitude", text: $longitude)
                        .keyboardType(.decimalPad)
                }
                Button(action: {
                    viewModel.validateAndOpenMap(latitude: latitude, longitude: longitude)
                }) {
                    Text("Open in Maps")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .alert(isPresented: Binding<Bool>(
                    get: { if case .none = viewModel.alertState { return false } else { return true } },
                    set: { _ in viewModel.alertState = .none }
                )) {
                    switch viewModel.alertState {
                    case .singleButton(let title, let message, let buttonText, let action):
                        return Alert(
                            title: Text(title),
                            message: Text(message),
                            dismissButton: .default(Text(buttonText)) {
                                action?()
                            }
                        )
                    case .doubleButton(let title, let message, let primaryButtonText, let secondaryButtonText, let primaryAction, let secondaryAction):
                        return Alert(
                            title: Text(title),
                            message: Text(message),
                            primaryButton: .default(Text(primaryButtonText)) {
                                primaryAction?()
                            },
                            secondaryButton: .cancel(Text(secondaryButtonText)) {
                                secondaryAction?()
                            }
                        )
                    case .none:
                        return Alert(title: Text("Unknown Error"))
                    }
                }
            }
            .navigationTitle("Enter Coordinates")
        }
    }
}
