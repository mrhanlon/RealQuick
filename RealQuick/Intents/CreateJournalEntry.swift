//
//  CreateJournalEntry.swift
//  RealQuick
//
//  Created by Matthew Hanlon on 4/26/23.
//

import Foundation
import AppIntents

struct CreateJournalEntry: AppIntent {
    static var title: LocalizedStringResource = "Create journal entry"
    static var description = IntentDescription("Creates a new journal entry")
    
    @Parameter(title: "Entry text")
    var entryText: String
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let journal = JournalEntryStore()
        try await journal.addEntry(JournalEntry(text: entryText, timestamp: Date.now))
        
        return .result()
    }
}
