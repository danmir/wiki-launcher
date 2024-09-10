import SwiftUI

@main
struct WikiLauncherApp: App {
    private let diContainer: DIContainer

    init() {
        self.diContainer = DIContainer()
    }

    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel(diContainer: diContainer))
        }
    }
}
