//
//  EntryList.swift
//  RealQuick
//
//  Created by Matthew Hanlon on 4/20/23.
//

import SwiftUI

struct EntryList: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.timestamp)
    ]) var entries: FetchedResults<JournalEntry>
    
    @State private var selectedEntry: JournalEntry?
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, H:mm"
        return formatter
    }()
    
    private func deleteEntry(at offsets: IndexSet) {
        for index in offsets {
            let entry = entries[index]
            moc.delete(entry)
        }
    }
    
    var body: some View {
        List {
            Section {
                ForEach(entries) { entry in
                    Button {
                        selectedEntry = entry
                    } label: {
                        Text(entry.timestamp!, format: Date.FormatStyle().month().day().hour().minute()
                        )
                    }
                    .foregroundColor(.primary)
                }
                .onDelete(perform: deleteEntry)
            } header: {
                Text(String(format: "%d quick entries", entries.count))
            }
        }
        .listStyle(.insetGrouped)
        .sheet(item: $selectedEntry) { entry in
            EntryDetail(entry: entry)
        }
        .background(Color("BackgroundColor"))
        .scrollContentBackground(.hidden)
    }
}

struct EntryList_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        EntryList()
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
