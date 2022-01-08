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
        Content()
            .isLoading(isLoading: bibleController.phase == .isLoading)
            .overlay(overlay(phase: bibleController.phase))
    }
    
    
    @ViewBuilder
    func overlay(phase: Phase) -> some View {
        switch phase {
        case .empty:
            OverlayView(text: "Ez a fordítás nem tartalmazza a keresett fejezetet", icon: "xmark.circle", isError: false) {}
        case .failure:
            OverlayView(text: bibleController.error?.errorDescription ?? "Hiba történt", icon: "xmark.icloud", isError: true) {}
        case .success, .isLoading:
            EmptyView()
        }
    }
}

// MARK: - ErrorView
extension BibleChapterView {
    struct OverlayView: View {
        var text: String
        var icon: String
        var isError: Bool
        var action: () -> Void
        var body: some View {
            VStack(spacing: 16) {
                Spacer()
                Spacer()
                Image(systemName: icon)
                    .font(.system(size: 56))
                Text(text)
                    .font(.Theme.regular(size: 19))
                    .multilineTextAlignment(.center)
                Button(action: action) {
                    Text("Próbálja meg újra")
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .font(.Theme.regular(size: 17))
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(4)
                        .padding(.horizontal)
                }
                .opacity(isError ? 1 : 0)
                Spacer()
                Spacer()
                Spacer()
            }
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
                Slider(value: $fontSize, in: 15.0...21.0, step: 2) { _ in }
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
//        NavigationView {
//            BibleChapterView()
//                .environmentObject(bibleController)
//        }
//        BibleChapterView()
//            .environmentObject(bibleController)
//            .environment(\.sizeCategory, .accessibilityMedium)
//        BibleChapterView()
//            .environmentObject(bibleController)
//            .environment(\.sizeCategory, .accessibilityLarge)
            
        BibleChapterView.OverlayView(text: "Szerver hiba", icon: "xmark.circle.fill", isError: true, action: {})
            .previewLayout(.sizeThatFits)
            .previewDisplayName("ErrorView")
        
        BibleChapterView.OverlayView(text: "Ez a fordítás...", icon: "xmark.circle", isError: false, action: {})
            .previewLayout(.sizeThatFits)
            .previewDisplayName("ErrorView")
        
       
    }
}
