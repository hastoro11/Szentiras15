//
//  HistoryListView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 31..
//

import SwiftUI

struct HistoryListView: View {
    @EnvironmentObject var readerVM: ReaderViewModel
    @EnvironmentObject var historyVM: HistoryViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(historyVM.historyList.indices, id: \.self) { index in
//                    historyRow(index: index)
                    HistoryRow(history: historyVM.historyList[index])
                        .onTapGesture {
                            readerVM.current = historyVM.historyList[index]
                            dismiss()
                        }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        withAnimation {
                            historyVM.removeFromHistory(index)
                        }
                    }
                    
                }
                .listRowSeparatorTint(.accentColor)
            }
            .overlay(overlay)
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                        Text("Vissza")
                    }
                    .font(.Theme.medium(size: 19))
                }
                ToolbarItem(placement: .principal) {
                    Text("Előzmények")
                        .font(.Theme.heavy(size: 19))
                        .foregroundColor(.primary)
                        .padding()
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        historyVM.removeAllHistory()
                    } label: {
                        Image(systemName: "trash")
                    }
                    .font(.Theme.medium(size: 17))
                    
                }
            }
            
        }
        .onAppear {
            historyVM.fetch()
        }
        
    }
    
    @ViewBuilder
    var overlay: some View {
        if historyVM.historyList.isEmpty {
            VStack {
                Spacer()
                Text("Nincsenek előzmények")
                    .font(.Theme.book(size: 18))
                Spacer()
            }
        } else {
            EmptyView()
        }
    }
}

struct HistoryRow: View {
    var history: Current
    var body: some View {
        HStack {
            Text("\(String(history.book.abbrev.prefix(3)))\(history.chapter)")
                .frame(width: 54, height: 44)
                .background(Color.Theme.background2)
                .foregroundColor(.white)
                .font(.Theme.heavy(size: 14))
            VStack(alignment: .leading, spacing: 0) {
                Text("\(history.book.name) \(history.chapter). fejezet")
                    .font(.Theme.medium(size: 15))
                    .lineLimit(1)
                    .foregroundColor(.Theme.grey2)

                HStack {
                    Text(history.translation.name)
                        .font(.Theme.oblique(size: 15))
                        .foregroundColor(.Theme.grey1)
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

struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryListView()
            .preferredColorScheme(.light)
            .environmentObject(HistoryViewModel.preview)
            .environmentObject(ReaderViewModel.preview)
        HistoryListView()
            .preferredColorScheme(.dark)
            .environmentObject(HistoryViewModel.preview)
            .environmentObject(ReaderViewModel.preview)
        HistoryRow(history: HistoryViewModel.preview.historyList[0])
            .previewLayout(.sizeThatFits)
    }
}
