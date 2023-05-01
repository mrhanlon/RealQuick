import SwiftUI
import Blackbird

struct EntryList: View {
    @BlackbirdLiveModels({ try await JournalEntry.read(from: $0, orderBy: .descending(\.$timestamp)) }) var entries
    
    @Environment(\.blackbirdDatabase) private var db
    
    @State private var isRecording = false
    
    private func deleteEntry(at offsets: IndexSet) {
        for index in offsets {
            Task {
                try await entries.results[index].delete(from: db!)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            if entries.didLoad {
                List {
                    ForEach(entries.results) { entry in
                        NavigationLink(destination: EntryDetail(entry: entry)) {
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
                    if entries.results.isEmpty {
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
                    RecordingSheet(isRecording: $isRecording)
                }
            } else {
                VStack {
                    Text("Loading...")
                }
            }
        }
    }
}

struct EntryList_Previews: PreviewProvider {
    static var database = try! Blackbird.Database.inMemoryDatabase()
    
    static var previews: some View {
        EntryList()
            .environment(\.blackbirdDatabase, database)
    }
}
