import SwiftUI

struct LocationCell: View {
    let location: LocationItem
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading) {
                Text(location.title)
                    .font(.headline)
                Text(location.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 2)
            .accessibilityHint("Proceeds to the wikipedia app with selected location")
        }
        .buttonStyle(PlainButtonStyle())
    }
}
