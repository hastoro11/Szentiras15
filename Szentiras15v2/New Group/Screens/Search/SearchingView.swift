//
//  SearchingView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 30..
//

import SwiftUI

// MARK: - SearchingView
struct SearchingView: View {
    var results: [TextResult.Result]
    var body: some View {
        Content(results: results)
    }
}

extension SearchingView {
    struct Content: View {
        var results: [TextResult.Result]
        @State var showFilterView: Bool = false
        var body: some View {
            VStack {
                SearchingView.SearchField(onCommit: {}, onClear: {}, onCancel: {})
                    .padding()
                SearchingView.FilterBar(count: results.count, showFilterView: $showFilterView)
                    .padding(.horizontal)
                SearchingView.SearchListView(results: results)
                Spacer()
                
            }
            .sheet(isPresented: $showFilterView) {
                SearchingView.FilterView()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

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
extension SearchingView {
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
                .navigationTitle("Szűrő")
            }
            
        }
    }

}

// MARK: - FilterBar
extension SearchingView {
    struct FilterBar: View {
        var count: Int
        var isActive: Bool = false
        @Binding var showFilterView: Bool
        var body: some View {
            HStack {
                Button(action: {
                    showFilterView.toggle()
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title2)
                        .iconButtonStyle(active: isActive)
                }
                Spacer()
                Text("\(count) találat")
                    .font(.Theme.regular(size: 17))
            }
        }
    }

}

// MARK: - SearchListView
extension SearchingView {
    struct SearchListView: View {
        var results: [TextResult.Result]
        var body: some View {
            List {
                ForEach(results.indices, id:\.self) { index in
                    SearchListRow(result: results[index])
                }
            }
            .listStyle(.plain)
        }
    }

}

// MARK: - SearchListRow
extension SearchingView.SearchListView {
    struct SearchListRow: View {
        var result: TextResult.Result
        var body: some View {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(result.book.abbrev) \(result.chapter),\(result.numv)")
                    .font(.Theme.medium(size: 15))
                Text(result.translation.abbrev.uppercased())
                    .font(.Theme.regular(size: 15))
                    .foregroundColor(Color.light)
                Text(result.text)
                    .font(.Theme.light(size: 15))
                    .foregroundColor(Color("Title"))
                    .lineLimit(3)
            }
            .padding(.bottom, 6)
        }
    }

}

// MARK: - SearchField
extension SearchingView {
    struct SearchField: View {
        @State var text: String = ""
        @State var isEditing: Bool = false
        var onCommit: () -> Void
        var onClear: () -> Void
        var onCancel: () -> Void
        
        var body: some View {
            HStack {
                TextField("Keresés ...", text: $text, onCommit: onCommit)
                    .padding(12)
                    .padding(.horizontal, 25)
                    .background(Color(uiColor: .systemGray5))
                    .cornerRadius(8)
                    .font(.Theme.light(size: 17))
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                            
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            if isEditing {
                                Button(action: {
                                    self.text = ""
                                    onClear()
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                            .foregroundColor(Color.dark)
                    )
                    .onTapGesture {
                        withAnimation {
                            self.isEditing = true
                        }
                    }
                if isEditing {
                    Button(action: {
                        withAnimation {
                            self.isEditing = false
                        }
                        self.text = ""
                        onCancel()
                        // Dismiss the keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Text("Mégsem")
                            .font(.Theme.regular(size: 17))
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                }
            }
            
        }
    }
    
}

// MARK: - Previews
struct SearchingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchingView(results: TestData.results)
        }
        
        SearchingView.FilterView()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("FilterView")
        
        SearchingView.FilterBar(count: 212, showFilterView: .constant(false))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("FilterBar")
        
        SearchingView.FilterBar(count: 212, isActive: true, showFilterView: .constant(true))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("FilterBar")
        
        SearchingView(results: TestData.results)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("SearchListView")
//            .environment(\.colorScheme, .dark)
        
        SearchingView.SearchListView.SearchListRow(result: TestData.results[0])
            .previewLayout(.sizeThatFits)
            .previewDisplayName("SearchListRow")
        
        Group {
            SearchingView.SearchField(text: "", isEditing: true, onCommit: {}, onClear: {}, onCancel: {})
            SearchingView.SearchField(text: "", isEditing: false, onCommit: {}, onClear: {}, onCancel: {})
            SearchingView.SearchField(text: "", isEditing: true, onCommit: {}, onClear: {}, onCancel: {})
                .environment(\.colorScheme, .dark)
            SearchingView.SearchField(text: "", isEditing: false, onCommit: {}, onClear: {}, onCancel: {})
                .environment(\.colorScheme, .dark)

        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("SearchField")
        
        
    }
}
