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
        @State var showHistoryList: Bool = false
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
                                .foregroundColor(.primary)
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            showHistoryList.toggle()
                        } label: {
                            Image(systemName: "list.star")
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
                .sheet(isPresented: $showHistoryList) {
                    BibleChapterView.HistoryListView(historyList: TestData.history)
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
                        SelectRow(abbrev: tr.abbrev.uppercased(), name: tr.name, selected: tr.id == currentTranslationID)
//                        BibleChapterView.TranslationListView.Row(abbrev: tr.abbrev.uppercased(), name: tr.name, selected: tr.id == currentTranslationID)
                            
                    }
                }
            }
            .listStyle(.plain)
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

// MARK: - HistoryListView
extension BibleChapterView {
    struct HistoryListView: View {
        var historyList: [Current]
        var body: some View {
            List {
                ForEach(historyList.indices, id:\.self) { index in
                    HistoryRow(history: historyList[index])
                }
            }
            .listStyle(.plain)
        }
    }

}

// MARK: - HistoryRow
extension BibleChapterView.HistoryListView {
    struct HistoryRow: View {
        var history: Current
        var body: some View {
            HStack {
                Text("\(String(history.book.abbrev.prefix(3)))\(history.chapter)")
                    .iconButtonStyle(active: false)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(history.book.name) \(history.chapter). fejezet")
                        .font(.Theme.medium(size: 15))
                        .lineLimit(1)
                        .foregroundColor(Color("Title"))

                    HStack {
                        Text(history.translation.name)
                            .font(.Theme.light(size: 14))
                            .foregroundColor(Color.dark
                            )
                            .lineLimit(1)
                        
                        Spacer()
                        Text(history.translation.abbrev.uppercased())
                            .foregroundColor(.accentColor)
                            .font(.Theme.medium(size: 15))
                    }
                    
                }
            }
        }
    }

}

// MARK: - Previews
struct BibleChapterView_Previews: PreviewProvider {
    static var idezet: Idezet = TestData.idezetRom16
    static var current: Current = TestData.current
    static var previews: some View {
        BibleChapterView(idezet: idezet, current: current)
        BibleChapterView(idezet: idezet, current: current)
            .environment(\.sizeCategory, .accessibilityMedium)
        BibleChapterView(idezet: idezet, current: current)
            .environment(\.sizeCategory, .accessibilityLarge)
            
        Group {
            BibleChapterView.VersList.VersRow(vers: idezet.valasz.versek[0], index: 0, fontSize: 17)
        }
        .previewLayout(.sizeThatFits)
        .previewDisplayName("VersRow")
        
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("RowIcon")
        
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
        
        BibleChapterView.HistoryListView(historyList: TestData.history)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("HistoryListView")
        
        BibleChapterView.HistoryListView.HistoryRow(history: TestData.history[0])
            .previewLayout(.sizeThatFits)
            .previewDisplayName("HistoryRow")
    }
}
