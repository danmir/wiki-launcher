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
                case .loaded(let locations):
                    locationsList(locations)
                case .error(let message):
                    ErrorView(message: message, retryAction: viewModel.fetchLocations)
                }
            }
            .navigationTitle("Locations")
            .refreshable {
                viewModel.fetchLocations()
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { if case .none = viewModel.alertState { return false } else { return true } },
            set: { _ in viewModel.alertState = .none }
        )) {
            AlertHelper.createAlert(for: viewModel.alertState)
        }
        .onAppear {
            viewModel.fetchLocations()
        }
        .onDisappear {
            viewModel.cancelTasks()
        }
    }
    
    @ViewBuilder
    private func locationsList(_ locations: [LocationItem]) -> some View {
        if locations.isEmpty {
            EmptyStateView()
        } else {
            List(locations) { location in
                LocationCell(location: location) {
                    viewModel.openMapApp(for: location)
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}
