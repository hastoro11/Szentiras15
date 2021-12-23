//
//  SearchView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 23..
//

import SwiftUI

// TODO: filter search - translation, old/newtestament, book

struct SearchView: View {
    @EnvironmentObject var vm: SearchViewModel
    @EnvironmentObject var readerVM: ReaderViewModel
    @Binding var tabSelection: TabSelection
    @State var search: String = ""
    @State var searched: Bool = false
    
    @State var showFilter: Bool = false
    var filterIsOn: Bool {
        filter != Filter(book: 0, translation: 0, testament: .none)
    }
    @State var filter: Filter = Filter(book: 0, translation: 0, testament: .none)
    
    var filteredResults: [TextResult.Result] {
        if case .success(let res) = vm.phase, let searchResult = res as? SearchResultWrapper, let fullTextResult = searchResult.fullTextResult{
            
            var filteredResults = fullTextResult.results.flatMap { $0.results}
            
            if filter.testament == .oldTestament {
                filteredResults = filteredResults.filter { $0.book.oldTestament == 1}
            }
            if filter.testament == .newTesmament {
                filteredResults = filteredResults.filter { $0.book.oldTestament == 0}
            }
            if filter.book != 0 {
                filteredResults = filteredResults.filter { $0.book.number == filter.book }
            }
            if filter.translation != 0 {
                filteredResults = filteredResults.filter { $0.translation.id == filter.translation }
            }
            return filteredResults
            
        }
        return []
    }
    
    var returnSucces: Bool {
        if case .success(_) = vm.phase {
            return true
        }
        
        return false
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $search, onCommit: onCommit, onClear: onClear, onCancel: onCancel)
                    .padding(.vertical, 4)
                    .padding(.horizontal)
                
                searchHeader
                
                SearchResultList(results: filteredResults, onTap: jumpToVers(result:))
                    .overlay(overlay)
                    .sheet(isPresented: $showFilter) {
                        FiltersView(showFilter: $showFilter, filter: $filter)
                    }
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Keresés")
                        .font(.Theme.bold(size: 17))
                }
            }
        }
    }
    
    var searchHeader: some View {
        HStack {
            Button {
                showFilter.toggle()
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .imageScale(.large)
                    .frame(width: 50, height: 44)
                    .foregroundColor(.white)
                    .background(filterIsOn ? Color.accentColor : Color.light)
            }
            .opacity(returnSucces ? 1 : 0)
            
            Spacer()
            Text("\(filteredResults.count) találat")
                .opacity(returnSucces ? 1 : 0)
        }
        .font(.Theme.regular(size: 17))
        .padding(.horizontal)
    }
    
    func jumpToVers(result: TextResult.Result) {
        readerVM.seekSearched = true
        readerVM.searchTag = "\(result.translation.id)/\(result.book.number)/\(result.chapter)/\(result.numv)"
        guard let book = Book.get(by: result.translation.id, and: result.book.number), let chapter = Int(result.chapter) else { return }
        let translation = Translation.get(by: result.translation.id)
        
        readerVM.current = Current(
            translation: translation,
            book: book,
            chapter: chapter)
        tabSelection = .read
        readerVM.load(current: readerVM.current)
    }
    
    @ViewBuilder
    var overlay: some View {
        switch vm.phase {
        case .isFetching:
            ProgressView("Keresés...")
        case .success(_):
            EmptyView()
        case .error(let error):
            VStack(spacing: 10) {
                Image(systemName: "exclamationmark.icloud.fill")
                    .font(.Theme.light(size: 48))
                Text("\(error.description)")
                    .font(.Theme.light(size: 17))
            }
            
        case .empty:
            VStack {
                Spacer()
                if searched && filteredResults.isEmpty {
                    Text("Nincs találat a(z) '\(search)' kifejezésre")
                        .font(.Theme.light(size: 17))
                } else {
                    Text("Kifejezés keresése a Bibliában...")
                        .font(.Theme.light(size: 17))
                }
                Spacer()
                Spacer()
            }
        }
    }
    
    func onClear() {
        search = ""
        searched = false
        vm.search(searchTerm: search)
    }
    
    func onCommit() {
        searched = true
        vm.search(searchTerm: search)
    }
    
    func onCancel() {
        search = ""
        searched = false
        filter = Filter(book: 0, translation: 0, testament: .none)
        vm.search(searchTerm: search)
    }
}

// MARK: - Previews
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(tabSelection: .constant(.search))
            .environmentObject(SearchViewModel.preview)
    }
}
