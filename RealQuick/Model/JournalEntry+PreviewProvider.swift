//
//  JournalEntry+PreviewProvider.swift
//  RealQuick
//
//  Created by Matthew Hanlon on 4/20/23.
//
import CoreData
import Foundation

extension JournalEntry {
    static var previewExample: JournalEntry {
        let context = DataController.preview.container.viewContext

        let fetchRequest: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let results = try? context.fetch(fetchRequest)

        return (results?.first!)!
    }
}
