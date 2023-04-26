import SwiftUI

struct EntryDetail: View {
    @Binding var entry: JournalEntry
    
    var body: some View {
        ScrollView {
            VStack {
                Text(entry.text)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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

struct EntryDetail_Previews: PreviewProvider {
    static var previews: some View {
        EntryDetail(entry: .constant(JournalEntry.sampleData[0]))
    }
}
