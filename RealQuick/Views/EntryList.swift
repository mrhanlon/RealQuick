//
//  EntryList.swift
//  RealQuick
//
//  Created by Matthew Hanlon on 4/20/23.
//

import SwiftUI

struct EntryList: View {
    @Binding var entries: [JournalEntry]
    @State private var isRecording = false
    
    private func addEntry(text: String) {
        print(text)
    }
    
    private func deleteEntry(at offsets: IndexSet) {
        print(entries.count)
        entries.remove(atOffsets: offsets)
        print(entries.count)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($entries) { $entry in
                    NavigationLink(destination: EntryDetail(entry: $entry)) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(entry.timestamp, style: .date)
                                Text(entry.timestamp, style: .time)
                            }
                            .font(.subheadline)
                            Text(entry.text).lineLimit(1)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteEntry)
            }
            .navigationTitle("Entries")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        isRecording = true
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(.accentColor)
                                .frame(width: 60, height: 60)
                            Label(
                                "Real Quick",
                                systemImage: "mic"
                            )
                            .labelStyle(.iconOnly)
                            .foregroundColor(.white)
                        }
                    }
                }
            }
            .sheet(isPresented: $isRecording) {
                print("Recording stopped!")
            } content: {
                RecordingSheet(entries: $entries, isRecording: $isRecording)
            }
        }
    }
}

struct EntryList_Previews: PreviewProvider {
    static var previews: some View {
        MockView()
    }
    
    struct MockView: View {
        @State var entries = JournalEntry.sampleData
        
        var body: some View {
            EntryList(entries: $entries)
        }
    }
}
