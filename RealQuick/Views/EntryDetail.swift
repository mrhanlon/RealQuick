import SwiftUI
import Blackbird

struct EntryDetail: View {
    @State var entry: JournalEntry?
    
    func populateAddress() async {
        guard entry != nil else {
            return
        }

        print("backfill address missing on JournalEntry \(entry!.id)")
        
        let address = await Address.resolve(entry!.latitude!, entry!.longitude!)
        
        guard address != nil else {
            return;
        }
        
        self.entry!.address = address!.description
        do {
            try await self.entry!.write(to: Database.shared)
        } catch {
            print(error.localizedDescription)
        }
    }
    
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
            .task {
                if entry.address == nil && entry.hasLocation() {
                    await populateAddress()
                }
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
        EntryDetail(entry: JournalEntry.sampleData[1])
        EntryDetail(entry: JournalEntry.sampleData[2])
    }
}
