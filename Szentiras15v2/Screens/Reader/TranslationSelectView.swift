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
            Button(action: {
                showTranslations.toggle()
            }) {
                Image(systemName: "chevron.left")
                Text("Vissza")
                Spacer()
            }
            .foregroundColor(.accentColor)
            .font(.Theme.heavy(size: 17))
            
            Divider()
            ForEach(Translation.all()) { tr in
                HStack {
                    Text(tr.abbrev.uppercased())
                        .font(.Theme.heavy(size: 15))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 44)
                        .background(tr.id == current.translation.id ? Color.accentColor : Color.Theme.background)
                    Text(tr.name)
                        .font(.custom("Avenir Book", size: 17))
                        .foregroundColor(tr.id == current.translation.id ? Color.Theme.dark : Color.Theme.text)
                }
                .onTapGesture {
                    fetch(translation: tr)
                    showTranslations = false
                }
                .padding(4)
                Divider()
            }
            Spacer()
        }
        .padding()
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
