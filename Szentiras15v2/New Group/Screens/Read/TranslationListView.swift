//
//  TranslationListView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 18..
//

import SwiftUI

// MARK: - TranslationListView
struct TranslationListView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var current: Current
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Translation.all()) { tr in
                    VStack {
                        SelectRow(abbrev: tr.abbrev.uppercased(), name: tr.name, selected: tr.id == current.translation.id)
                            .onTapGesture {
                                changeTranslation(ID: tr.id)
                            }
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Fordítások")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Mégsem") { dismiss() }
                }
            }
        }
    }
    
    // MARK: changeTranslation(ID:)
    func changeTranslation(ID: Int) {
        let translation = Translation.get(by: ID)
        let book = translation.getBooks().first(where: {$0.number == current.book.number}) ?? current.book
        current.translation = translation
        current.book = book
        dismiss()
    }
}


// MARK: - Previews
struct Previews_TranslationListView_Previews: PreviewProvider {
    static var previews: some View {
        TranslationListView(current: .constant(TestData.current))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("TranslationList")
        
    }
}
