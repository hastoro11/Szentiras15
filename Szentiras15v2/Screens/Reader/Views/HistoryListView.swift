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
                    historyRow(index: index)
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
                        .foregroundColor(.black)
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
    
    func historyRow(index: Int) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(historyVM.historyList[index].book.abbrev)  \(historyVM.historyList[index].chapter)")
                .font(.Theme.medium(size: 17))
            Text("\(historyVM.historyList[index].book.name) \(historyVM.historyList[index].chapter). fejezet")
                .font(.Theme.book(size: 17))
                .lineLimit(2)
                .foregroundColor(.Theme.button)
                .padding(.bottom,6)
            Text(historyVM.historyList[index].translation.name)
                .font(.Theme.oblique(size: 17))
                .foregroundColor(.Theme.text)
                .lineLimit(1)
        }
    }
}

struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryListView()
            .environmentObject(HistoryViewModel.preview)
            .environmentObject(ReaderViewModel.preview)
    }
}
