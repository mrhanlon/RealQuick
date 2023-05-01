import Foundation
import Blackbird
import CoreLocation

struct JournalEntry: BlackbirdModel {
    static var primaryKey: [BlackbirdColumnKeyPath] = [ \.$id ]
    
    @BlackbirdColumn var id: String = UUID().uuidString
    @BlackbirdColumn var text: String
    @BlackbirdColumn var timestamp: Date
    @BlackbirdColumn var address: String?
    @BlackbirdColumn var latitude: Double?
    @BlackbirdColumn var longitude: Double?
    
    var coordinate: CLLocationCoordinate2D? {
        if latitude != nil && longitude != nil {
            return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        } else {
            return nil
        }
    }
}

extension JournalEntry {
    static let sampleData: [JournalEntry] = [
            JournalEntry(
                id: UUID().uuidString,
                text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.",
                timestamp: Date.from(2023, 04, 12, 06, 17, 03)!,
                address: "2503 Arbor Dr, Round Rock, TX 78681",
                latitude: 37.785834,
                longitude: -122.406417
            ),
            JournalEntry(
                id: UUID().uuidString,
                text: "At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
                timestamp: Date.from(2023, 04, 15, 12, 27, 42)!
            ),
            JournalEntry(
                id: UUID().uuidString,
                text: "The quick red fox jumped over the lazy brown dog.",
                timestamp: Date.from(2023, 04, 23, 11, 59, 17)!
            ),
    ]
}
