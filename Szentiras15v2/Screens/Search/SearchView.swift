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
    
    var results: [TextResult.Result] {
        if case .empty = vm.phase {
            return []
        }
        if case .success(let res) = vm.phase, let searchResult = res as? SearchResult, let fullTextResult = searchResult.fullTextResult{
            return fullTextResult.results.flatMap { $0.results}
        }
        
        return []
    }
    
    var filteredResults: [TextResult.Result] {
        if case .success(let res) = vm.phase, let searchResult = res as? SearchResult, let fullTextResult = searchResult.fullTextResult{
            
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
    var body: some View {
        VStack {
            SearchBar(text: $search, onCommit: onCommit, onClear: onClear, onCancel: onCancel)
                .padding()
            HStack {
                Button {
                    showFilter.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .imageScale(.large)
                        .frame(width: 50, height: 44)
                        .foregroundColor(.white)
                        .background(filterIsOn ? Color.accentColor : Color.Theme.background)
                }
                .opacity(returnSucces ? 1 : 0)
                
                Spacer()
                Text("\(filteredResults.count) találat")
                    .opacity(returnSucces ? 1 : 0)
            }
            .font(.Theme.book(size: 17))
            .padding(.horizontal)
            resultList
                .overlay(overlay)
                .sheet(isPresented: $showFilter) {
                    FilterView(showFilter: $showFilter, filter: $filter)
                }
            Spacer()
        }
    }
    
    var resultList: some View {
        List {
            ForEach(filteredResults.indices, id:\.self) { index in
                resultRow(result: filteredResults[index])
                    .onTapGesture {
                        jumpToVers(result: filteredResults[index])
                    }
            }
        }
        .listStyle(.plain)
    }
    
    func jumpToVers(result: TextResult.Result) {
        readerVM.seekSearched = true
        readerVM.searchTag = "\(result.translation.id)/\(result.book.number)/\(result.chapter)/\(result.numv)"
        guard let book = Book.get(by: result.translation.id, and: result.book.number), let translation = Translation.get(by: result.translation.id), let chapter = Int(result.chapter) else { return }
        
        readerVM.current = Current(
            translation: translation,
            book: book,
            chapter: chapter)
        tabSelection = .read
        readerVM.load(current: readerVM.current)
    }
    
    func resultRow(result: TextResult.Result) -> some View {
        VStack(alignment: .leading) {
            Text("\(result.book.abbrev) \(result.chapter),\(result.numv)")
                .font(.Theme.heavy(size: 15))
            Text(result.translation.abbrev.uppercased())
                .font(.Theme.oblique(size: 15))
                .foregroundColor(.Theme.text)
            Text(result.text)
                .font(.Theme.book(size: 15))
                .foregroundColor(Color.Theme.button)
                .lineLimit(3)
        }
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
                    .font(.Theme.light(size: 19))
            }
            
        case .empty:
            if searched && results.isEmpty {
                Text("Nincs találat a(z) '\(search)' kifejezésre")
            } else {
                Text("Kifejezés keresése a Bibliában...")
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(tabSelection: .constant(.search))
            .environmentObject(SearchViewModel.preview)
    }
}
