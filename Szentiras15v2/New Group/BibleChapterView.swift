//
//  BibleChapterView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 27..
//

import SwiftUI

struct BibleChapterView: View {
    var idezet: Idezet
    var current: Current
    
    var body: some View {
        NavigationView {
            Content(idezet: idezet, current: current)
                      
        }
    }
}

// MARK: - Content
extension BibleChapterView {
    struct Content: View {
        typealias VersList = BibleChapterView.VersList
        
        var idezet: Idezet
        var current: Current
        @State var showBookList: Bool = false
        @State var showTranslationList: Bool = false
        var body: some View {
            VersList(versek: idezet.valasz.versek)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            showTranslationList.toggle()
                        }) {
                            Text(current.translation.abbrev.uppercased())
                                .font(.Theme.regular(size: 17))
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Button {
                            showBookList.toggle()
                        } label: {
                            Text(idezet.keres.hivatkozas)
                                .font(.Theme.medium(size: 17))
                        }
                    }
                }
                .sheet(isPresented: $showBookList) {
                    BibleChapterView.BookListView(current: current, showBookList: showBookList)
                }
                .sheet(isPresented: $showTranslationList) {
                    BibleChapterView.TranslationListView(currentTranslationID: current.translation.id)
                }
        }
    }
}

// MARK: - BookListView
extension BibleChapterView {
    struct BookListView: View {
        var current: Current
        @State var showBookList = false
        var body: some View {
            ScrollViewReader { proxy in
                List {
                    ForEach(Book.getBooksByCategories(byTranslationID: current.translation.id), id:\.id) { category in
                        Section {
                            ForEach(category.books.indices, id:\.self) { index in
                                BookRow(book: category.books[index], current: current)
                            }
                        } header: {
                            Text(category.title)
                        }
                    }
                }
                .listStyle(.grouped)
            }
        }
    }
    
}

// MARK: - BookRow
extension BibleChapterView.BookListView {
    struct BookRow: View {
        var book: Book
        var current: Current
        @State var isExpanded: Bool
        init(book: Book, current: Current) {
            self.book = book
            self.current = current
            _isExpanded = State(initialValue: book.number == current.book.number)
//            _isExpanded = State(initialValue: false)
        }
        var body: some View {
            DisclosureGroup(isExpanded: $isExpanded) {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50, maximum: 60))], spacing: 15) {
                        ForEach(1...(book.chapters), id:\.self) { ch in
                            Button(action: {}) {
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

// MARK: - TranslationListView
extension BibleChapterView {
    struct TranslationListView: View {
        var currentTranslationID: Int
        var body: some View {
            List {
                ForEach(Translation.all()) { tr in
                    VStack {
                        BibleChapterView.TranslationListView.Row(abbrev: tr.abbrev.uppercased(), name: tr.name, selected: tr.id == currentTranslationID)
                            
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

// MARK: - Row
extension BibleChapterView.TranslationListView {
    struct Row: View {
        var abbrev: String
        var name: String
        var selected: Bool
        var body: some View {
            HStack {
                Text(abbrev.uppercased())
                    .iconButtonStyle(active: selected)
                Text(name)
                    .font(.Theme.light(size: 17))
                    .foregroundColor(selected ? Color("Title") : Color.light)
                Spacer()
            }
        }
    }

}

// MARK: - VersList
extension BibleChapterView {
    struct VersList: View {
        var versek: [Vers]
        var body: some View {
            ScrollViewReader { proxy in
                List {
                    ForEach(versek.indices, id:\.self) { index in
                        VersRow(vers: versek[index], index: index, fontSize: 17)
                            
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

// MARK: - VersRow
extension BibleChapterView.VersList {
    struct VersRow: View {
        var vers: Vers
        var index: Int
        var fontSize: CGFloat
        
        var body: some View {
            Text(attributedText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        var attributedText: AttributedString {
            var attributedIndex = AttributedString("\(vers.versSzam) ")
            attributedIndex.foregroundColor = .accentColor
            attributedIndex.font = .Theme.bold(size: fontSize)
            var attributedString = AttributedString(vers.szoveg)
            attributedString.font = .Theme.light(size: fontSize)
            attributedString.foregroundColor = Color("Title")
            let result = attributedIndex + attributedString
            return result
        }
    }
    
    
}

// MARK: - Previews
struct BibleChapterView_Previews: PreviewProvider {
    static var idezet: Idezet = TestData.idezetRom16
    static var current: Current = TestData.current
    static var previews: some View {
        BibleChapterView(idezet: idezet, current: current)
        Group {
            BibleChapterView.VersList.VersRow(vers: idezet.valasz.versek[0], index: 0, fontSize: 17)
        }
        .previewLayout(.sizeThatFits)
        .previewDisplayName("VersRow")
        
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("RowIcon")
        
        VStack {
            BibleChapterView.TranslationListView.Row(abbrev: "RUF", name: "Magyar Bibliatársulat újfordítású Bibliája (2014)", selected: false)
            BibleChapterView.TranslationListView.Row(abbrev: "RUF", name: "Magyar Bibliatársulat újfordítású Bibliája (2014)", selected: true)
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("TranslationRow")
        
        BibleChapterView.TranslationListView(currentTranslationID: 6)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("TranslationList")
        
        BibleChapterView.BookListView.BookRow(book: TestData.current.book, current: TestData.current)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("BookRow")
        
        BibleChapterView.BookListView(current: TestData.current)
            .previewDisplayName("BookLisView")
    }
}
