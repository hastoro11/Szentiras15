//
//  BooksListView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 22..
//

import SwiftUI

struct BooksListView: View {
    @Environment(\.dismiss) var dismiss
    var current: Current    
    var books: [Book] {
        current.translation.getBooks()
    }
    var load: (Current) -> Void
    var body: some View {
        VStack {
            VStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                    Text("Vissza")
                    Spacer()
                }
                .foregroundColor(.accentColor)
                .font(.Theme.regular(size: 17))
                Divider()
            }
            .padding([.horizontal, .top])
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(books.indices, id:\.self) { index in
                        BookRow(fetch: fetch, current: current, book: books[index])
                            .id(books[index].number)
                    }
                }
                .onAppear {
                    proxy.scrollTo(current.book.number)
                }
            }
        }
    }

    func fetch(book: Book, chapter: Int) {
        let current = Current(
            translation: current.translation,
            book: book,
            chapter: chapter)
        self.load(current)
    }
}

struct BooksListView_Previews: PreviewProvider {
    static var current: Current = Current(translation: Translation.get(by: 4)!, book: Book.default, chapter: 1)
    static var previews: some View {
        BooksListView(current: current, load: {_ in})
    }
}
