import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "mappin.slash")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            Text("No locations available")
                .font(.headline)
            Text("Try refreshing the list or check back later")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
