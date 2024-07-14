//
//  HistoryPage.swift
//  F1 Start Timer
//
//  Created by Fardin Kamal on 14/7/24.
//

import SwiftUI
import SwiftData

struct HistoryPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        List {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                DisclosureGroup("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))") {
                    Text("Reacted in \(String(format: "%.3f", item.time))s")
                }
            }
            .onDelete(perform: deleteItems)
            
            if (items.count != 0){
                Button("Delete All", systemImage: "trash") {
                    deleteAll()
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            }
        }

#if os(macOS)
        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
        .toolbar {
#if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
#endif
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }

    private func deleteAll() {
        withAnimation {
            items.forEach { item in
                modelContext.delete(item)
            }
        }
    }
}

#Preview {
    HistoryPage()
}
