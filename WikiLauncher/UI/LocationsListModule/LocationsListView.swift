import SwiftUI

struct LocationsListView: View {
    @StateObject private var viewModel: LocationsListViewModel

    init(viewModel: LocationsListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView("Loading...")
                        .navigationTitle("Locations")
                case .loaded(let locations):
                    if locations.isEmpty {
                        Text("No locations available.")
                            .navigationTitle("Locations")
                    } else {
                        List(locations) { location in
                            LocationCell(location: location) {
                                viewModel.openMapApp(for: location)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .navigationTitle("Locations")
                    }
                case .error(let message):
                    VStack {
                        Text(message)
                            .foregroundColor(.red)
                        Button("Retry") {
                            viewModel.fetchLocations()
                        }
                        .padding(.top, 10)
                    }
                    .navigationTitle("Locations")
                }
            }
            .onAppear {
                viewModel.fetchLocations()
            }
            .onDisappear {
                viewModel.cancelTasks()
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
    }
}
