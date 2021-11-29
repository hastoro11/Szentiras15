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
            Content(idezet: idezet)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {}) {
                            Text(current.translation.abbrev.uppercased())
                                .font(.Theme.regular(size: 17))
                        }
                    }
                }
        }
    }
}

// MARK: - Content
extension BibleChapterView {
    struct Content: View {
        typealias VersList = BibleChapterView.VersList
        
        var idezet: Idezet
        var body: some View {
            VersList(versek: idezet.valasz.versek)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(idezet.keres.hivatkozas)
        }
    }
}

// MARK: - BookListView
extension BibleChapterView {
    struct BookListView: View {
        var books: [Book]
        var current: Current
        var body: some View {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(books.indices, id:\.self) { index in
                        BookRow(book: books[index], current: current)
                    }
                }
            }
        }
    }

}

// MARK: - BookRow
extension BibleChapterView.BookListView {
    struct BookRow: View {
        var book: Book
        var current: Current
        var body: some View {
            DisclosureGroup {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50, maximum: 60))], spacing: 15) {
                        ForEach(1...(book.chapters), id:\.self) { ch in
                            Button(action: {}) {
                                Text("\(ch)")
                                    .foregroundColor(.white)
                                    .font(.Theme.medium(size: 17))
                                    .frame(width: 44, height: 44)
                                    .background(Rectangle().fill (Color.light))
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
        var translations: [Translation] = Translation.all()
        var currentTranslationID: Int = 6
        var body: some View {
            List {
                ForEach(translations) { tr in
                    VStack {
                        SelectRow(abbrev: tr.abbrev.uppercased(), name: tr.name, selected: tr.id == currentTranslationID)
                            
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
        typealias RowIcon = BibleChapterView.TranslationListView.RowIcon
        var abbrev: String
        var name: String
        var selected: Bool
        var body: some View {
            HStack {
                RowIcon(text: abbrev.uppercased(), selected: selected)
                Text(name)
                    .font(.Theme.light(size: 17))
                    .foregroundColor(selected ? Color("Title") : Color.light)
                Spacer()
            }
        }
    }

}

// MARK: - RowIcon
extension BibleChapterView.TranslationListView {
    struct RowIcon: View {
        var text: String
        var selected: Bool
        var body: some View {
            Text(text)
                .font(.Theme.bold(size: 15))
                .foregroundColor(Color.white)
                .frame(width: 50, height: 44)
                .background(selected ? Color.accentColor : Color.light)
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
        
        HStack {
            BibleChapterView.TranslationListView.RowIcon(text: "SZIT", selected: true)
            BibleChapterView.TranslationListView.RowIcon(text: "SZIT", selected: false)
        }
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
        
        BibleChapterView.TranslationListView()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("TranslationList")
        
        BibleChapterView.BookListView.BookRow(book: TestData.current.book, current: TestData.current)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("BookRow")
        
        BibleChapterView.BookListView(books: TestData.books, current: TestData.current)
            .previewDisplayName("BookLisView")
    }
}
