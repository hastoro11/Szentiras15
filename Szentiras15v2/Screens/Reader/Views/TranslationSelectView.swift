//
//  TranslationSelectView.swift
//  TranslationSelectView
//
//  Created by Gabor Sornyei on 2021. 09. 12..
//

import SwiftUI

struct TranslationSelectView: View {
    var current: Current
    @Binding var showTranslations: Bool
    var load: (Current) -> Void
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Button(action: {
                    showTranslations.toggle()
                }) {
                    Image(systemName: "chevron.left")
                    Text("Vissza")
                    Spacer()
                }
                .foregroundColor(.accentColor)
                .font(.Theme.regular(size: 17))
                Text("Fordítások")
                    .font(.Theme.bold(size: 17))
                    .foregroundColor(.primary)
            }
            .padding([.top, .horizontal])
            .padding(.bottom, 6)
            List {
                ForEach(Translation.all()) { tr in
                    VStack {
                        SelectRow(abbrev: tr.abbrev.uppercased(), name: tr.name, selected: tr.id == current.translation.id)
                            .onTapGesture {
                                fetch(translation: tr)
                                showTranslations = false
                            }
                    }
                }
            }
            .listStyle(.plain)
            Spacer()
        }
    }
    
    func fetch(translation: Translation) {
        let current = Current(
            translation: translation,
            book: current.book,
            chapter: current.chapter)
        self.load(current)
    }
}

struct TranslationSelectView_Previews: PreviewProvider {
    static var current: Current = Current(translation: Translation.default, book: Book.default, chapter: 1)
    static var previews: some View {
        TranslationSelectView(current: current, showTranslations: .constant(true), load: {_ in})
    }
}
