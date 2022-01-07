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
            Content()
        case .isLoading:
            ProgressView("Keresés...")
        case .failure:
            VStack {
                Text(bibleController.error?.errorDescription ?? "OK")
                Button("Újra") {
                    Task {
                        await bibleController.fetch()
                    }
                }
            }
        default:
            EmptyView()
        }
    }
}

// MARK: - Content
extension BibleChapterView {
    struct Content: View {
        @EnvironmentObject var bibleController: BibleController
        @EnvironmentObject var partialSheet: PartialSheetManager
        @AppStorage("fontSize") var fontSize: Double = 17
        var verses: [Vers] {
            bibleController.idezet.valasz.versek
        }
        var title: String {
            bibleController.idezet.keres.hivatkozas
        }
        var current: Current {
            bibleController.current
        }
        @State var showBookList: Bool = false
        @State var showTranslationList: Bool = false
        @State var showHistoryList: Bool = false
        var body: some View {
            VersList(verses: verses)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        
                        HStack {
                            Button(action: {
                                partialSheet.showPartialSheet {
                                    ReaderSettingView(fontSize: $fontSize)
                                }
                            }) {
                                Text("Aa")
                            }
                            Button(action: {
                                showTranslationList.toggle()
                            }) {
                                Text(current.translation.abbrev.uppercased())
                                    .font(.Theme.regular(size: 17))
                            }
                            
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
                .addPartialSheet()
        }
    }
}

// MARK: - FontSettingsView
extension BibleChapterView {
    struct FontSettingsView: View {
        @Binding var fontSize: Double
        var body: some View {
            VStack(alignment: .leading) {
                Text("Betűméret")
                    .font(.Theme.medium(size: 17))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Slider(value: $fontSize, in: 15.0...21.0, step: 2) { _ in
//                    if UserDefaults.standard.isFontSizeSaved {
//                        UserDefaults.standard.saveFontSize(fontSize: fontSize)
//                    }
                }
                .padding(.bottom)
            }
            .padding()
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
            
        
        
       
    }
}
