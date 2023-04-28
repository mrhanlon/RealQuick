//
//  IntentsExtension.swift
//  RealQuick
//
//  Created by Matthew Hanlon on 4/26/23.
//

import Foundation
import AppIntents

struct RealQuickShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: CreateJournalEntry(),
            phrases: [
                "\(.applicationName)",
                "\(.applicationName) entry",
                "\(.applicationName) journal",
                "\(.applicationName) journal entry",
                "Create entry with \(.applicationName)",
                "Create journal entry with \(.applicationName)",
                "Create \(.applicationName) entry",
                "Create \(.applicationName) journal entry",
                "Make a \(.applicationName) entry",
                "Make a \(.applicationName) journal entry",
            ],
            systemImageName: "mic.fill"
        )
    }
}
