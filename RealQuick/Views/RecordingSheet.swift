import SwiftUI
import Blackbird

struct RecordingSheet: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @StateObject var locationManager = LocationManager()

    @Environment(\.blackbirdDatabase) var database
    @Binding var isRecording: Bool
    
    private func addEntry(_ text: String) {
        let entry = JournalEntry(
            text: text,
            timestamp: Date.now,
            address: locationManager.address,
            latitude: locationManager.location?.latitude,
            longitude: locationManager.location?.longitude)
            
        Task {
            try await entry.write(to: database!)
        }
    }
    
    private func getLocation() {
        locationManager.checkPermission { enabled in
            locationManager.requestLocation()
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
            .onAppear {
                getLocation()
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
