//
//  FilterView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 21..
//

import SwiftUI


// MARK: - Filter Struct
struct SearchFilter {
    enum Testament: String, CaseIterable {
        case none = ""
        case oldTestament = "Ószövetség"
        case newTestament = "Újszövetség"
    }
    var book: Int = 0
    var testament: Testament = .none
    var translation: Int = 0
}


// MARK: - FilterView
struct FilterView: View {
    @State var activeFilter: SearchFilter = SearchFilter()
    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker(selection: $activeFilter.book) {
                        Text("Nincs kiválasztás")
                            .tag(0)
                        ForEach(Book.combined) { book in
                            Text(book.name)
                                .tag(book.number)
                        }
                    } label: {
                        Text(activeFilter.book == 0 ? "" : Book.getBookInCombined(byNumber: activeFilter.book).abbrev.prefix(4))
                            .iconButtonStyle(active: true)
                    }
                    
                } header: {
                    Text("Könyvek")
                }
                
                Section {
                    Group {
                        SelectingRow(abbrev: "", text: "Nincs kiválasztás", selected: activeFilter.testament == .none, isAligned: true)
                            .tag(SearchFilter.Testament.none)
                        SelectingRow(abbrev: "Ósz", text: "Ószövetség", selected: activeFilter.testament == .oldTestament, isAligned: true)
                            .tag(SearchFilter.Testament.oldTestament)
                        SelectingRow(abbrev: "Úsz", text: "Újszövetség", selected: activeFilter.testament == .newTestament, isAligned: true)
                            .tag(SearchFilter.Testament.newTestament)
                    }
                } header: {
                    Text("Ó- vagy Újszövetség")
                }
                
                Section {
                    SelectingRow(abbrev: "", text: "Nincs kiválasztás", selected: activeFilter.translation == 0, isAligned: true)
                        .tag(0)
                    ForEach(Translation.all()) { tr in
                        SelectingRow(abbrev: tr.abbrev.uppercased(), text: tr.name, selected: activeFilter.translation == tr.id, isAligned: true)
                            .tag(tr.id)
                    }
                } header: {
                    Text("Fordítások")
                }
                
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Szűrés")
        }
        
    }
}



// MARK: - Previews
struct Previews_FilterViews_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("FilterView")
        
    }
}
