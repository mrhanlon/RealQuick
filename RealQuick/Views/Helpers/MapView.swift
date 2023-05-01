import SwiftUI
import MapKit

struct MapView: View {
    var entry: JournalEntry
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
    var body: some View {
        if entry.coordinate != nil {
            VStack {
                Text(entry.address ?? "")
                    .textSelection(.enabled)
                
                Map(
                    coordinateRegion: $region,
                    annotationItems: [entry],
                    annotationContent: { entry in
                        MapMarker(coordinate: entry.coordinate!, tint: .accentColor)
                    }
                )
            }
            .onAppear {
                setRegion(entry.coordinate!)
            }
        } else {
            VStack {
                Text("No recorded location")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("BackgroundColor"))
        }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
    }
}
