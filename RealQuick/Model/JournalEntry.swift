import Foundation
//import CoreLocation

struct JournalEntry: Identifiable, Codable {
    var id: UUID
    var text: String
    var timestamp: Date
    
//    private var coordinates: Coordinates
//    var locationCoordinate: CLLocationCoordinate2D {
//
//        CLLocationCoordinate2D(latitude: coordinates.latitude,
//                               longitude: coordinates.longitude)
//    }
//
//    struct Coordinates: Hashable, Codable {
//        var latitude: Double
//        var longitude: Double
//    }
    
    init(id: UUID = UUID(), text: String, timestamp: Date = Date.now) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
    }
}

extension JournalEntry {
    static let sampleData: [JournalEntry] = [
            JournalEntry(
                text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.",
                timestamp: Date.from(2023, 04, 12, 06, 17, 03)!
            ),
            JournalEntry(
                text: "At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
                timestamp: Date.from(2023, 04, 15, 12, 27, 42)!
            ),
            JournalEntry(
                text: "The quick red fox jumped over the lazy brown dog.",
                timestamp: Date.from(2023, 04, 23, 11, 59, 17)!
            ),
    ]
}
