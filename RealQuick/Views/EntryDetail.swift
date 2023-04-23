//
//  EntryDetail.swift
//  RealQuick
//
//  Created by Matthew Hanlon on 4/20/23.
//

import SwiftUI

struct EntryDetail: View {
    @Environment(\.dismiss) var dismiss
    
    var entry: JournalEntry
    
    var body: some View {
        VStack {
            Text(entry.timestamp!, format: Date.FormatStyle().month().day().hour().minute())
            Text(entry.text!)
            Spacer()
            Button {
                dismiss()
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(.accentColor)
                        .frame(width: 30, height: 30)
                    Label("Close", systemImage: "xmark")
                        .labelStyle(.iconOnly)
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
    }
}

struct EntryDetail_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        EntryDetail(entry: JournalEntry.previewExample)
    }
}
