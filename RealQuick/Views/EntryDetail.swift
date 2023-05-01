import SwiftUI
import Blackbird

struct EntryDetail: View {
    var entry: JournalEntry?
    
    var body: some View {
        if let entry {
            ScrollView {
                VStack {
                    Text(entry.text)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                MapView(entry: entry)
                    .frame(height: 150)
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text(entry.timestamp, style: .date)
                        Text(entry.timestamp, style: .time)
                    }
                }
            }
        }
    }
}

struct EntryDetail_Previews: PreviewProvider {
    static var previews: some View {
        EntryDetail(entry: JournalEntry.sampleData[0])
    }
}
