//
//  ContentView.swift
//  RealQuick
//
//  Created by Matthew Hanlon on 4/10/23.
//

import SwiftUI

struct ContentView: View {
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.timestamp)
    ]) var entries: FetchedResults<JournalEntry>
    
    @Environment(\.managedObjectContext) var moc
    
    func addEntry() {
        let text = "Lorem ipsum"
        let timestamp = Date()
        print(String(format: "Real Quick! \(Date())"))
        
        let entry = JournalEntry(context: moc)
        entry.id = UUID()
        entry.text = text
        entry.timestamp = timestamp
        
        try? moc.save()
    }
    
    func removeEntry(at offsets: IndexSet) {
        for index in offsets {
            let entry = entries[index]
            moc.delete(entry)
        }
    }
    
    var body: some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, H:mm"
    
        return VStack {
            Image(systemName: "bicycle")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Text(String(format: "%d quick entries", entries.count))
            List {
                ForEach(entries) { entry in
                    Text(formatter.string(from: entry.timestamp!))
                }.onDelete(perform: removeEntry)
            }
            Button(action: addEntry) {
                Text("Real Quick")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
