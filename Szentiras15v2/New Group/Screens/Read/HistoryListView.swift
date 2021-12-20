//
//  HistoryListView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 20..
//

import SwiftUI

// MARK: - HistoryListView
struct HistoryListView: View {
    @Environment(\.dismiss) var dismiss
    var historyList: [Current]
    @Binding var current: Current
    var deleteAll: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                ForEach(historyList.indices, id:\.self) { index in
                    HistoryRow(history: historyList[index])
                        .onTapGesture {
                            current = historyList[index]
                            dismiss()
                        }
                }
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Előzmények")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Mégsem") {
                        dismiss()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        deleteAll()
                        dismiss()
                    }) {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
}

// MARK: - HistoryRow
extension HistoryListView {
    struct HistoryRow: View {
        var history: Current
        var body: some View {
            HStack {
                Text("\(String(history.book.abbrev.prefix(3))) \(history.chapter)")
                    .iconButtonStyle(active: false)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(history.book.name) \(history.chapter). fejezet")
                        .font(.Theme.medium(size: 15))
                        .lineLimit(1)
                        .foregroundColor(Color("Title"))

                    HStack {
                        Text(history.translation.name)
                            .font(.Theme.light(size: 14))
                            .foregroundColor(Color.dark
                            )
                            .lineLimit(1)
                        
                        Spacer()
                        Text(history.translation.abbrev.uppercased())
                            .foregroundColor(.accentColor)
                            .font(.Theme.medium(size: 15))
                    }
                    
                }
            }
        }
    }

}

// MARK: - Previews
struct Previews_HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryListView(historyList: TestData.history, current: .constant(TestData.current), deleteAll: {})
            .previewLayout(.sizeThatFits)
            .previewDisplayName("HistoryListView")
        
        HistoryListView.HistoryRow(history: TestData.history[0])
            .previewLayout(.sizeThatFits)
            .previewDisplayName("HistoryRow")
    }
}
