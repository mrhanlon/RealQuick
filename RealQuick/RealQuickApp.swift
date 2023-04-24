//
//  RealQuickApp.swift
//  RealQuick
//
//  Created by Matthew Hanlon on 4/10/23.
//

import SwiftUI

@main
struct VoiceLogApp: App {
    @State private var entries = JournalEntry.sampleData
    
    var body: some Scene {
        WindowGroup {
            EntryList(entries: $entries)
        }
    }
}
