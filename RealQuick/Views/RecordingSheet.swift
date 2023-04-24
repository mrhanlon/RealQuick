//
//  RecordEntry.swift
//  RealQuick
//
//  Created by Matthew Hanlon on 4/20/23.
//

import SwiftUI

struct RecordingSheet: View {
    @State private var entry = JournalEntry(text: "", timestamp: Date.now)
    @Binding var entries: [JournalEntry]
    @Binding var isRecording: Bool
    
    private func addEntry(text: String) {
        entry.text = text
        entries.append(entry)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Real Quick, recording...")
            }
            .navigationTitle("Recording")
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
                        addEntry(text: "Recording finished! Saved recording using the \"Done\" button.")
                        isRecording = false
                    } label: {
                        Text("Done")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        addEntry(text: "Recording finished! Saved recording using the \"Stop\" button.")
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
        }
        .onAppear {
            print("Recording started?!")
        }
    }
}

struct RecordEntry_Previews: PreviewProvider {
    static var previews: some View {
        RecordingSheet(entries: .constant(JournalEntry.sampleData), isRecording: .constant(true))
    }
}
