import Foundation
import CoreData

@MainActor
class JournalEntryStore: ObservableObject {
    @Published var entries: [JournalEntry] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("journal.data")
    }
    
    func load() async throws {
        let task = Task<[JournalEntry], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let entries = try JSONDecoder().decode([JournalEntry].self, from: data)
            return entries
        }
        let entries = try await task.value
        self.entries = entries
    }
    
    func save() async throws {
        let task = Task {
            let data = try JSONEncoder().encode(self.entries)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value

    }
    
    func addEntry(_ entry: JournalEntry) async throws {
        try await self.load()
        print("Intent loaded \(self.entries.count) entries")
        self.entries.append(entry)
        try await self.save()
        print("Intent saved \(self.entries.count) entries")
    }
}
