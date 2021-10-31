//
//  BookRow.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 22..
//

import SwiftUI

struct BookRow: View {
    @State var isOpen: Bool
    @Binding var showBookslist: Bool
    var fetch: (Book, Int) -> Void
    var current: Current
    var book: Book
    
    init(showBookslist: Binding<Bool>, fetch: @escaping (Book, Int) -> Void, current: Current, book: Book) {
        _showBookslist = showBookslist
        self.fetch = fetch
        self.current = current
        self.book = book
        _isOpen = State(wrappedValue: book.number == current.book.number)
    }
    
    var body: some View {
        DisclosureGroup(isExpanded: $isOpen){
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50, maximum: 60))], spacing: 15) {
                    ForEach(1...(book.chapters), id:\.self) { ch in
                        Button(action: {
                            showBookslist.toggle()
                            
                            fetch(book, ch)
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
            HStack {
                Text(book.name)
                    .font(.Theme.book(size: 17))
                    .lineLimit(1)
                Spacer()
                Text(book.abbrev)
                    .font(.Theme.medium(size: 17))
            }
            .foregroundColor(.Theme.title)
        }
        .padding(.horizontal)
        Divider()
            .padding(.horizontal)
    }
}

struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        BookRow(showBookslist: .constant(true), fetch: {_, _ in}, current: Current.init(translation: Translation.default, book: Book.default, chapter: 1), book: Book.default)
    }
}
