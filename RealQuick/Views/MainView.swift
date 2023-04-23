//
//  ContentView.swift
//  RealQuick
//
//  Created by Matthew Hanlon on 4/10/23.
//

import SwiftUI
import Speech
import CoreLocation

struct MainView: View {
    @Environment(\.managedObjectContext) var moc
    
    //    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    //    private let audioEngine = AVAudioEngine()
    //
    //    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    //    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var isRecording = false
    //    @State private var speechText = ""
    //
    //    private func startRecording() {
    //        let inputNode = audioEngine.inputNode
    //
    //        guard let recognitionRequest = recognitionRequest else {
    //            print("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
    //            return
    //        }
    //
    //        let recordingFormat = inputNode.outputFormat(forBus: 0)
    //        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
    //            recognitionRequest.append(buffer)
    //        }
    //
    //        audioEngine.prepare()
    //
    //        do {
    //            try audioEngine.start()
    //        } catch {
    //            print("audioEngine couldn't start because of an error: \(error)")
    //            return
    //        }
    //
    //        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
    //            guard let result = result else {
    //                print("Recognition failed with error: \(error?.localizedDescription ?? "Unknown error")")
    //                return
    //            }
    //
    //            speechText = result.bestTranscription.formattedString
    //        }
    //    }
    //
    //    private func stopRecording() {
    //        audioEngine.stop()
    //        recognitionRequest?.endAudio()
    //        recognitionTask?.cancel()
    //
    //        recognitionRequest = nil
    //        recognitionTask = nil
    //
    //        print(speechText)
    //        addEntry(text: speechText)
    //    }
    //
    //    private func checkPermissions() {
    //        SFSpeechRecognizer.requestAuthorization { authStatus in
    //            DispatchQueue.main.async {
    //                switch authStatus {
    //                case .authorized: break
    //                default: handlePermissionFailed()
    //                }
    //            }
    //        }
    //    }
    //
    //    private func handlePermissionFailed() {
    //        // Present an alert asking the user to change their settings.
    //        let ac = UIAlertController(title: "This app must have access to speech recognition to work.",
    //                                   message: "Please consider updating your settings.", preferredStyle: .alert)
    //        ac.addAction(UIAlertAction(title: "Open settings", style: .default) { _ in
    //            let url = URL(string: UIApplication.openSettingsURLString)!
    //            UIApplication.shared.open(url)
    //        })
    //        ac.addAction(UIAlertAction(title: "Close", style: .cancel))
    //    }
    
    private func addEntry(text: String) {
        let timestamp = Date()
        print(String(format: "Real Quick! \(Date())"))
        
        let entry = JournalEntry(context: moc)
        entry.id = UUID()
        entry.text = text
        entry.timestamp = timestamp
        
        try? moc.save()
    }
    
    var body: some View {
        return NavigationStack {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack {
                    Image(systemName: "bicycle")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    
                    Divider()
                        .background(.ultraThinMaterial)
                    
                    EntryList()
                }
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(action: {
                            if isRecording {
                                addEntry(text: "Lorem ipsum dolor amet")
                            }
                            isRecording.toggle()
                        }) {
                            ZStack {
                                Circle()
                                    .foregroundColor(.accentColor)
                                    .frame(width: 60, height: 60)
                                Label(
                                    isRecording ? "Stop" : "Real Quick",
                                    systemImage: isRecording ? "stop" : "mic"
                                )
                                .labelStyle(.iconOnly)
                                .foregroundColor(.white)
                            }
                        }
                    }
            }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        MainView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
