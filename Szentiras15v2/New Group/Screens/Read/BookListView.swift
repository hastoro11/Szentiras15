//
//  BookListView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 18..
//

import SwiftUI

// MARK: - BookListView
struct BookListView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var current: Current
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                List {
                    ForEach(Book.getBooksByCategories(byTranslationID: current.translation.id), id:\.id) { category in
                        Section {
                            ForEach(category.books.indices, id:\.self) { index in
                                BookRow(book: category.books[index], current: $current, dismiss: {dismiss()})
                            }
                        } header: {
                            Text(category.title)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("A Biblia könyvei")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Mégsem") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - BookRow
extension BookListView {
    struct BookRow: View {
        var book: Book
        @Binding var current: Current
        @State var isExpanded: Bool
        var dismiss: () -> Void
        
        init(book: Book, current: Binding<Current>, dismiss: @escaping () -> Void) {
            self.book = book
            _current = current
            _isExpanded = State(initialValue: book.number == current.wrappedValue.book.number)
            self.dismiss = dismiss
        }
        var body: some View {
            DisclosureGroup(isExpanded: $isExpanded) {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50, maximum: 60))], spacing: 15) {
                        ForEach(1...(book.chapters), id:\.self) { ch in
                            Button(action: {
                                current.book = book
                                current.chapter = ch
                                dismiss()
                            }) {
                                Text("\(ch)")
                                    .iconButtonStyle(active: ch == current.chapter, size: .small)
                            }
                        }
                    }
                }
                .padding(.vertical)
            } label: {
                HStack {
                    Text(book.name)
                        .font(.Theme.light(size: 17))
                        .lineLimit(1)
                    Spacer()
                    Text(book.abbrev)
                        .font(.Theme.medium(size: 17))
                }
                .foregroundColor(Color("Title"))
            }
        }
    }
    
}


struct Previews_BookListView_Previews: PreviewProvider {
    static var bibleController = BibleController.preview
    static var previews: some View {
        BookListView.BookRow(book: TestData.current.book, current: .constant(TestData.current), dismiss: {})
            .previewLayout(.sizeThatFits)
            .previewDisplayName("BookRow")
        
        BookListView(current: .constant(TestData.current))
            .environmentObject(bibleController)
            .previewDisplayName("BookLisView")
    }
}
