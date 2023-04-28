import SwiftUI

struct EntryList: View {
    @Binding var entries: [JournalEntry]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isRecording = false
    let saveAction: ()->Void
    let loadAction: ()->Void
    
    private func deleteEntry(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
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
            .overlay(Group {
                if entries.isEmpty {
                    Text("No data")
                }
            })
            .navigationTitle("Entries")
            .navigationBarTitleDisplayMode(.automatic)
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
                RecordingSheet(entries: $entries, isRecording: $isRecording)
            }
            .onChange(of: scenePhase) { phase in
                if phase == .background { saveAction() }
                else if phase == .active { loadAction() }
            }
        }
    }
}

struct EntryList_Previews: PreviewProvider {
    static var previews: some View {
        MockView()
        EntryList(entries: .constant([]), saveAction: {}, loadAction: {})
    }
    
    struct MockView: View {
        @State var entries = JournalEntry.sampleData
        
        var body: some View {
            EntryList(entries: $entries, saveAction: {}, loadAction: {})
        }
    }
}
