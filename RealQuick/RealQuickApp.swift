import SwiftUI

@main
struct RealQuickApp: App {
    @StateObject private var journal = JournalEntryStore()
    
    var body: some Scene {
        WindowGroup {
            EntryList(entries: $journal.entries) {
                Task {
                    do {
                        try await journal.save()
                        print("saved journal data")
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            } loadAction: {
                Task {
                    do {
                        try await journal.load()
                        print("loaded journal data; \(journal.entries.count) entries")
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
//            .task {
//                do {
//                    try await journal.load()
//                } catch {
//                    fatalError(error.localizedDescription)
//                }
//            }
        }
    }
}
