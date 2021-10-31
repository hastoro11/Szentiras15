//
//  HistoryListView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 31..
//

import SwiftUI

struct HistoryListView: View {
    @EnvironmentObject var readerVM: ReaderViewModel
    @Environment(\.dismiss) var dismiss
    var history: [Current] {
        readerVM.historyService.history
    }
    var body: some View {
        NavigationView {
            List {
                ForEach(readerVM.historyService.history.indices) { index in
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(history[index].book.abbrev)  \(history[index].chapter)")
                            .font(.Theme.medium(size: 17))
                        Text("\(history[index].book.name) \(history[index].chapter). fejezet")
                            .font(.Theme.book(size: 17))
                            .lineLimit(2)
                            .foregroundColor(.Theme.button)
                            .padding(.bottom,6)
                        Text(history[index].translation.name)
                            .font(.Theme.oblique(size: 17))
                            .foregroundColor(.Theme.text)
                            .lineLimit(1)
                    }
                    .onTapGesture {
                        readerVM.current = history[index]
                        dismiss()
                    }
                }                
            }
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
                    Text("Előző fejezetek")
                        .font(.Theme.black(size: 19))
                        .foregroundColor(.black)
                        .padding()
                }
            }
            
        }
        
    }
}

struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryListView()
            .environmentObject(ReaderViewModel.preview)
    }
}
