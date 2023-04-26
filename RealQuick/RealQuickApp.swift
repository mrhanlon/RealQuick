import SwiftUI

@main
struct RealQuickApp: App {
    @StateObject private var journal = JournalEntryStore()
    
    var body: some Scene {
        WindowGroup {
            EntryList(entries: $journal.entries) {
                Task {
                    do {
                        try await journal.save(entries: journal.entries)
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
            .task {
                do {
                    try await journal.load()
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}
