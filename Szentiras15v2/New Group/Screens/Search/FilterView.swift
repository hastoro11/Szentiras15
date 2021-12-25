//
//  FilterView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 21..
//

import SwiftUI


// MARK: - Filter Struct
struct SearchFilter: Equatable {
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
    @Environment(\.dismiss) var dismiss
    @Binding var searchFilter: SearchFilter
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker(selection: $searchFilter.book) {
                        Text("Nincs kiválasztás")
                            .tag(0)
                        ForEach(Book.combined) { book in
                            Text(book.name)
                                .tag(book.number)
                        }
                    } label: {
                        Text(searchFilter.book == 0 ? "" : Book.getBookInCombined(byNumber: searchFilter.book).abbrev.prefix(4))
                            .iconButtonStyle(active: true)
                    }
                    
                } header: {
                    Text("Könyvek")
                }
                
                Section {
                    Group {
                        SelectingRow(abbrev: "", text: "Nincs kiválasztás", selected: searchFilter.testament == .none, isAligned: true)
                            .tag(SearchFilter.Testament.none)
                            .onTapGesture { searchFilter.testament = .none }
                        SelectingRow(abbrev: "Ósz", text: "Ószövetség", selected: searchFilter.testament == .oldTestament, isAligned: true)
                            .tag(SearchFilter.Testament.oldTestament)
                            .onTapGesture { searchFilter.testament = .oldTestament }
                        SelectingRow(abbrev: "Úsz", text: "Újszövetség", selected: searchFilter.testament == .newTestament, isAligned: true)
                            .tag(SearchFilter.Testament.newTestament)
                            .onTapGesture { searchFilter.testament = .newTestament }
                    }
                } header: {
                    Text("Ó- vagy Újszövetség")
                }
                
                Section {
                    SelectingRow(abbrev: "", text: "Nincs kiválasztás", selected: searchFilter.translation == 0, isAligned: true)
                        .tag(0)
                    ForEach(Translation.all()) { tr in
                        SelectingRow(abbrev: tr.abbrev.uppercased(), text: tr.name, selected: searchFilter.translation == tr.id, isAligned: true)
                            .tag(tr.id)
                            .onTapGesture { searchFilter.translation = tr.id }
                    }
                } header: {
                    Text("Fordítások")
                }
                
                
            }
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigation) {
                    Button("Mégsem") {
                        searchFilter = SearchFilter()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        searchFilter = SearchFilter()
                    }) {
                        Image(systemName: "trash")
                            .opacity(searchFilter == SearchFilter() ? 0 : 1)
                    }
                }
                ToolbarItem(placement: ToolbarItemPlacement.primaryAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Szűrés")
                            .bold()
                            .opacity(searchFilter == SearchFilter() ? 0 : 1)
                    }
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
        FilterView(searchFilter: .constant(SearchFilter()))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("FilterView")
        
    }
}
