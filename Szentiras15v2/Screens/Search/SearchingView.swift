//
//  SearchingView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 30..
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

// MARK: - SearchingView
struct SearchingView: View {
    @EnvironmentObject var searchController: SearchController
    @State var showFilterView: Bool = false
    @State var searchTerm: String = ""
    @State var searchFilter: SearchFilter = SearchFilter()
    
    var body: some View {
        VStack {
            SearchField(text: $searchTerm, onCommit: {
                Task {
                    await searchController.fetch(searchTerm: searchTerm)
                }
            }, onClear: resetSearchResults, onCancel: resetSearchResults)
                .padding(.horizontal)
            SearchingView.FilterBar(count: filterResults().count, showFilterView: $showFilterView, searchFilter: $searchFilter)
                .padding(.horizontal)
            if searchController.phase == .success {
                if filterResults().isEmpty {
                    message(text: "Nincs találat!")
                } else {
                    SearchingView.SearchListView(results: filterResults())
                }
            } else if searchController.phase == .isLoading {
                Spacer()
                ProgressView("Keresés...")
            } else {
                message(text: "Írj be egy kifejezést, amire keresni szeretnél")
            }
            Spacer()
        }       
        .navigationTitle("Keresés")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func resetSearchResults() {
        searchController.resetSearchResults()
        searchTerm = ""
        searchFilter = SearchFilter()
    }
    
    func filterResults() ->[SearchResult]  {
        var results = searchController.searchResults
        switch searchFilter.testament {
        case .newTestament:
            results = results.filter { $0.bookNumber > 200}
        case .oldTestament:
            results = results.filter { $0.bookNumber < 200}
        default:
            break
        }
        if searchFilter.book != 0 {
            results = results.filter { $0.bookNumber == searchFilter.book }
        }
        if searchFilter.translation != 0 {
            results = results.filter { $0.translationID == searchFilter.translation}
        }
        return results.sorted(by: {$0.bookNumber < $1.bookNumber })
    }
    
    func message(text: String) -> some View {
        Text(text)
            .font(.Theme.light(size: 17))
            .multilineTextAlignment(.center)
            .padding(.top, 40)
            .padding(.horizontal)
    }
}

// MARK: - SearchListView
extension SearchingView {
    struct SearchListView: View {
        var results: [SearchResult]
        @State var selectedVers: SearchResult = .default
        @State var selected: Bool = false
        var body: some View {
            NavigationLink(isActive: $selected) {
                SearchVersListView(searchResult: selectedVers)
            } label: {
                EmptyView()
            }
            .padding(.bottom, 4)
            
            List {
                ForEach(results.indices, id:\.self) { index in
                    SearchListRow(result: results[index])
                        .onTapGesture {
                            selected.toggle()
                            selectedVers = results[index]
                        }
                }
            }
            .listStyle(.plain)
        }
    }
    
}

// MARK: - SearchListRow
extension SearchingView.SearchListView {
    struct SearchListRow: View {
        var result: SearchResult
        var translation: Translation
        var book: Book
        init(result: SearchResult) {
            self.result = result
            self.translation = Translation.get(by: result.translationID)
            self.book = Book.get(by: result.translationID, and: result.bookNumber) ?? Book.default
        }
        var body: some View {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(book.abbrev) \(result.chapter),\(result.numv)")
                    .font(.Theme.medium(size: 15))
                Text(translation.abbrev.uppercased())
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

// MARK: - FilterBar
extension SearchingView {
    struct FilterBar: View {
        var count: Int
        @Binding var showFilterView: Bool
        @Binding var searchFilter: SearchFilter
        
        var body: some View {
            VStack {
                HStack {
                    Spacer()
                    Text("\(count) találat")
                        .font(.Theme.regular(size: 17))
                }
                Picker(selection: $searchFilter.translation) {
                    Text("Mind").tag(0)
                    ForEach(Translation.all()) { tr in
                        Text(tr.abbrev).tag(tr.id)
                    }
                    
                } label: {
                    Text("")
                }
                .pickerStyle(.segmented)
                Picker("", selection: $searchFilter.testament) {
                    Text("Mind").tag(SearchFilter.Testament.none)
                    Text("Ószöv").tag(SearchFilter.Testament.oldTestament)
                    Text("Újszöv").tag(SearchFilter.Testament.newTestament)
                }
                .pickerStyle(.segmented)
                
                HStack {
                    Text("Könyvek")
                        .font(.Theme.regular(size: 17))
                    Spacer()
                    Picker("", selection: $searchFilter.book) {
                        Text("Mind")
                            .tag(0)
                        ForEach(Book.combined) { book in
                            Text(book.name)
                                .tag(book.number)
                            
                        }
                    }
                    .pickerStyle(MenuPickerStyle.menu)
                }
                .padding(.bottom)
            }
        }
    }
}


// MARK: - Previews
struct SearchingView_Previews: PreviewProvider {
    static var searchController: SearchController = SearchController.preview
    static var previews: some View {
        NavigationView {
            SearchingView()
                .environmentObject(searchController)
        }

        SearchingView()
            .environmentObject(searchController)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("SearchListView")
        //            .environment(\.colorScheme, .dark)

        SearchingView.SearchListView.SearchListRow(result: TestData.searchResults[0])
            .previewLayout(.sizeThatFits)
            .previewDisplayName("SearchListRow")

        
        SearchingView.FilterBar(count: 212, showFilterView: .constant(false), searchFilter: .constant(SearchFilter()))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("FilterBar")

        SearchingView.FilterBar(count: 212, showFilterView: .constant(true), searchFilter: .constant(SearchFilter()))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("FilterBar")
        
    }
}
