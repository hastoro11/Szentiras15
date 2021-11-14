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
        VStack {
            ZStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                    Text("Vissza")
                    Spacer()
                }
                .foregroundColor(.accentColor)
                .font(.Theme.regular(size: 17))
                Text("Előzmények")
                    .font(.Theme.bold(size: 17))
                    .foregroundColor(.primary)
                HStack {
                    Spacer()
                    Button {
                        historyVM.removeAllHistory()
                    } label: {
                        Image(systemName: "trash")
                    }
                    .font(.Theme.regular(size: 17))
                }
            }
            .padding([.top, .horizontal])
            .padding(.bottom, 6)
            List {
                ForEach(historyVM.historyList.indices, id: \.self) { index in
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
                    .font(.Theme.medium(size: 18))
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
                .background(Color(uiColor: .systemGray3))
                .foregroundColor(.white)
                .font(.Theme.bold(size: 16))
            VStack(alignment: .leading, spacing: 2) {
                Text("\(history.book.name) \(history.chapter). fejezet")
                    .font(.Theme.medium(size: 15))
                    .lineLimit(1)
                    .foregroundColor(.primary)

                HStack {
                    Text(history.translation.name)
                        .font(.Theme.light(size: 14))
                        .foregroundColor(Color(uiColor: UIColor.systemGray))
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
