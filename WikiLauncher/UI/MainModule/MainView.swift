import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModel

    var body: some View {
        TabView {
            LocationsListView(viewModel: viewModel.makeLocationsListViewModel())
                .tabItem {
                    Image(systemName: "list.bullet")
                        .accessibilityLabel("Bullets icon")
                    Text("Locations")
                        .accessibilityLabel("Predefined list of locations")
                }

            CustomCoordinatesView(viewModel: viewModel.makeCustomCoordinatesViewModel())
                .tabItem {
                    Image(systemName: "map")
                        .accessibilityLabel("Map icon")
                    Text("Enter Coordinates")
                        .accessibilityLabel("Custom location entry")
                }
        }
    }
}
