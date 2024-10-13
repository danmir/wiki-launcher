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
                        .accessibilityLabel("Latitude input")
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Longitude", text: $longitude)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel("Longitude input")
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Section {
                    Button(action: {
                        viewModel.validateAndOpenMap(latitude: latitude, longitude: longitude)
                    }) {
                        Text("Open in Maps")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .disabled(latitude.isEmpty || longitude.isEmpty)
                    .buttonStyle(PrimaryButtonStyle())
                    .accessibilityLabel("Open in Maps button")
                }
            }
            .navigationTitle("Enter Coordinates")
            .alert(isPresented: Binding<Bool>(
                get: { if case .none = viewModel.alertState { return false } else { return true } },
                set: { _ in viewModel.alertState = .none }
            )) {
                AlertHelper.createAlert(for: viewModel.alertState)
            }
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
