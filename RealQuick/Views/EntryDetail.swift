//
//  EntryDetail.swift
//  RealQuick
//
//  Created by Matthew Hanlon on 4/20/23.
//

import SwiftUI

struct EntryDetail: View {
    @Binding var entry: JournalEntry
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(entry.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle(
            "\(Text(entry.timestamp, style: .date)) \(Text(entry.timestamp, style: .time))"
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EntryDetail_Previews: PreviewProvider {
    static var previews: some View {
        EntryDetail(entry: .constant(JournalEntry.sampleData[0]))
    }
}
