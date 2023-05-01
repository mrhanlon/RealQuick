//
//  CreateJournalEntry.swift
//  RealQuick
//
//  Created by Matthew Hanlon on 4/26/23.
//

import Foundation
import AppIntents
import Blackbird

struct CreateJournalEntry: AppIntent {
    static var title: LocalizedStringResource = "Create journal entry"
    static var description = IntentDescription("Creates a new journal entry")

    @Parameter(title: "Entry text")
    var entryText: String
    
    @MainActor
    func perform() async throws -> some IntentResult {
        var entry = JournalEntry(text: entryText, timestamp: Date.now)
        // TODO location
        
        do {
            try await entry.write(to: Database.shared)
        } catch {
            print(error.localizedDescription)
        }
        
        return .result(value: "Got it!")
    }
}
