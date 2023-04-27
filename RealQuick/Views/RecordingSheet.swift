import SwiftUI

struct RecordingSheet: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @Binding var entries: [JournalEntry]
    @Binding var isRecording: Bool
    @State var newEntryText: String = ""
    
    private func addEntry(_ text: String) {
        entries.append(JournalEntry(text: text, timestamp: Date.now))
    }
    
    private func startRecording() {
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
    }
    
    private func finishRecording() {
        speechRecognizer.stopTranscribing();
        addEntry(speechRecognizer.transcript)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Listening")
                    Image(systemName: "mic.fill")
                }.font(.title)
                Spacer()
                Text("This should display the transcribed text in real time, but it doesn't yet...")
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isRecording = false
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isRecording = false
                    } label: {
                        Text("Done")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        isRecording = false
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
                startRecording()
            }
            .onDisappear {
                finishRecording()
            }
        }
    }
}

struct RecordEntry_Previews: PreviewProvider {
    static var previews: some View {
        RecordingSheet(entries: .constant(JournalEntry.sampleData), isRecording: .constant(true))
    }
}
