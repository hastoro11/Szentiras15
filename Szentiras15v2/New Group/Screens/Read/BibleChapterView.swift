//
//  BibleChapterView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 27..
//

import SwiftUI

struct BibleChapterView: View {
    @EnvironmentObject var bibleController: BibleController
    
    var body: some View {
        switch bibleController.phase {
        case .success:
            Content(
                verses: bibleController.idezet.valasz.versek,
                title: bibleController.idezet.keres.hivatkozas,
                current: bibleController.current)
        case .isLoading:
            ProgressView("Keresés...")
        case .failure:
            Text(bibleController.error?.errorDescription ?? "OK")
        default:
            EmptyView()
        }
    }
}

// MARK: - Content
extension BibleChapterView {
    struct Content: View {
        @EnvironmentObject var bibleController: BibleController
        typealias VersList = BibleChapterView.VersList
        
        var verses: [Vers]
        var title: String
        var current: Current
        @State var showBookList: Bool = false
        @State var showTranslationList: Bool = false
        @State var showHistoryList: Bool = false
        var body: some View {
            VersList(verses: verses)
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
                            Text(title)
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
                .sheet(isPresented: $showBookList, onDismiss: {
                    Task {
                        await bibleController.fetch()
                    }
                }) {
                    BookListView(current: $bibleController.current)
                }
                .sheet(isPresented: $showTranslationList, onDismiss: {
                    Task {
                        await bibleController.fetch()
                    }
                }) {
                    TranslationListView(current: $bibleController.current)
                        .environmentObject(bibleController)
                }
                .sheet(isPresented: $showHistoryList, onDismiss: {
                    Task {
                        await bibleController.fetch()
                    }
                }) {
                    HistoryListView(historyList: bibleController.history, current: $bibleController.current) { bibleController.deleteAllHistory()}
                }
        }
    }
}


// MARK: - VersList
extension BibleChapterView {
    struct VersList: View {
        var verses: [Vers]
        var body: some View {
            ScrollViewReader { proxy in
                List {
                    ForEach(verses.indices, id:\.self) { index in
                        VersRow(vers: verses[index], index: index, fontSize: 17)
                            
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
    static var bibleController = BibleController.preview
    static var previews: some View {
        NavigationView {
            BibleChapterView()
                .environmentObject(bibleController)
        }
        BibleChapterView()
            .environmentObject(bibleController)
            .environment(\.sizeCategory, .accessibilityMedium)
        BibleChapterView()
            .environmentObject(bibleController)
            .environment(\.sizeCategory, .accessibilityLarge)
            
        Group {
            BibleChapterView.VersList.VersRow(vers: idezet.valasz.versek[0], index: 0, fontSize: 17)
        }
        .previewLayout(.sizeThatFits)
        .previewDisplayName("VersRow")
        
       
    }
}
