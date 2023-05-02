import SwiftUI
import Blackbird
import CoreLocation

struct RecordingSheet: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @StateObject var locationManager = LocationManager()
    let geocoder = CLGeocoder()

    @Environment(\.blackbirdDatabase) var database
    @Binding var isRecording: Bool
    
    @State var location: CLLocation?
    @State var place: CLPlacemark?
    
    private func addEntry(_ text: String) {
        let coordinate = location?.coordinate
        var address: Address?
        
        if let place {
            address = Address(place)
        }
        
        let entry = JournalEntry(
            text: text,
            timestamp: Date.now,
            address: address?.description,
            latitude: coordinate?.latitude,
            longitude: coordinate?.longitude)
            
        Task {
            try await entry.write(to: database!)
        }
    }
    
    private func startRecording() {
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
    }
    
    private func finishRecording() {
        speechRecognizer.stopTranscribing();
        addEntry(speechRecognizer.transcript)
    }
    
    private func cancelRecording() {
        speechRecognizer.stopTranscribing();
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Listening")
                    Image(systemName: "mic.fill")
                    Image(systemName: locationManager.locationEnabled ? "location.fill" : "location.slash")
                }.font(.title)
                Spacer()
                Text(speechRecognizer.transcript)
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isRecording = false
                        cancelRecording()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isRecording = false
                        finishRecording()
                    } label: {
                        Text("Done")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        isRecording = false
                        finishRecording()
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundColor(.accentColor)
                                .frame(width: 60, height: 60)
                            Label("Close", systemImage: "stop.fill")
                                .labelStyle(.iconOnly)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .task {
                do {
                    location = await locationManager.getLocation()
                    if let location {
                        let places = try await geocoder.reverseGeocodeLocation(location)
                        place = places.first
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            .onAppear {
                locationManager.checkPermission()
                startRecording()
            }
        }
    }
}

struct RecordEntry_Previews: PreviewProvider {
    static let database = try! Blackbird.Database.inMemoryDatabase()
    static var previews: some View {
        RecordingSheet(isRecording: .constant(true))
            .environment(\.blackbirdDatabase, database)
    }
}
