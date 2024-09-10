import Foundation

protocol LocationBuilder {
    func buildLocationItems(from dto: [LocationDTO]) -> [LocationItem]
}

final class LocationBuilderImpl: LocationBuilder {
    func buildLocationItems(from dto: [LocationDTO]) -> [LocationItem] {
        return dto.map { item -> LocationItem in
            let title = item.name ?? "Point (\(item.lat), \(item.long))"
            let subtitle = "@ (\(item.lat), \(item.long))"
            return LocationItem(
                id: UUID().uuidString,
                title: title,
                subtitle: subtitle,
                model: item
            )
        }
    }
}
