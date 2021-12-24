//
//  SearchingView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 30..
//

import SwiftUI

// MARK: - SearchingView
struct SearchingView: View {
    @EnvironmentObject var searchController: SearchController
    @State var showFilterView: Bool = false
    @State var searchTerm: String = ""
    var body: some View {
        VStack {
            SearchField(text: $searchTerm, onCommit: {
                Task {
                    await searchController.fetch(searchTerm: searchTerm)
                }
            }, onClear: resetSearchResults, onCancel: resetSearchResults)
                .padding()
            SearchingView.FilterBar(count: searchController.searchResults.count, showFilterView: $showFilterView, disabled: searchController.searchResults.isEmpty)
                .padding(.horizontal)
            if searchController.phase == .success {
                SearchingView.SearchListView(results: searchController.searchResults)                
            } else if searchController.phase == .isLoading {
                Spacer()
                ProgressView("Keresés...")
            } else {
                EmptyView()
            }
            Spacer()
        }       
        .sheet(isPresented: $showFilterView) {
            FilterView()
        }
        .navigationTitle("Keresés")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func resetSearchResults() {
        searchController.resetSearchResults()
        searchTerm = ""
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
                            print(selectedVers)
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
        var isActive: Bool = false
        @Binding var showFilterView: Bool
        var disabled: Bool
        var body: some View {
            HStack {
                Button(action: {
                    showFilterView.toggle()
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title2)
                        .iconButtonStyle(active: isActive)
                }
                .disabled(disabled)
                Spacer()
                Text("\(count) találat")
                    .font(.Theme.regular(size: 17))
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

        
        SearchingView.FilterBar(count: 212, showFilterView: .constant(false), disabled: false)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("FilterBar")

        SearchingView.FilterBar(count: 212, isActive: true, showFilterView: .constant(true), disabled: false)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("FilterBar")
        
    }
}
