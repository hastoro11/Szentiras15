//
//  BooksListView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 22..
//

import SwiftUI

struct BooksListView: View {
    @Binding var showBookslist: Bool
    var current: Current    
    var books: [Book] {
        current.translation.getBooks()
    }
    var load: (Current) -> Void
    var body: some View {
        VStack {
            VStack {
                Button(action: {
                    showBookslist.toggle()
                }) {
                    Image(systemName: "chevron.left")
                    Text("Vissza")
                    Spacer()
                }
                .foregroundColor(.accentColor)
                .font(.Theme.heavy(size: 17))
                Divider()
            }
            .padding([.horizontal, .top])
            ScrollView {
                ForEach(books.indices, id:\.self) { index in
                    bookRow(book: books[index])
                    
                }
            }
            .listStyle(.plain)
        }
    }
    
    @ViewBuilder
    func bookRow(book: Book) -> some View {
        DisclosureGroup {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50, maximum: 60))], spacing: 15) {
                    ForEach(1...(book.chapters), id:\.self) { ch in
                        Button(action: {
                            showBookslist.toggle()
                            fetch(book: book, chapter: ch)
                        }) {
                            Text("\(ch)")
                                .foregroundColor(.white)
                                .font(.Theme.heavy(size: 17))
                                .frame(width: 44, height: 44)
                                .background(Rectangle().fill (
                                    book.number == current.book.number && ch == current.chapter ? Color.accentColor : Color.Theme.background
                                ))
                        }
                    }
                }
            }
            .padding(.vertical)
        } label: {
            Text(book.name)
                .font(.Theme.book(size: 17))
        }
        .padding(.horizontal)
        Divider()
            .padding(.horizontal)
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
    static var current: Current = Current(translation: Translation.default, book: Book.default, chapter: 1)
    static var previews: some View {
        BooksListView(showBookslist: .constant(true), current: current, load: {_ in})
    }
}
