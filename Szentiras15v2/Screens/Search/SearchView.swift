//
//  SearchView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 23..
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var vm: SearchViewModel
    @EnvironmentObject var readerVM: ReaderViewModel
    @Binding var tabSelection: TabSelection
    @State var search: String = ""
    @State var searched: String = ""
    var results: [TextResult.Result] {
        if case .empty = vm.phase {
            return []
        }
        if case .success(let res) = vm.phase, let searchResult = res as? SearchResult, let fullTextResult = searchResult.fullTextResult{
            return fullTextResult.results.flatMap { $0.results}
        }
        
        return []
    }
    var hitCount: String? {
        if case .success(let res) = vm.phase, let searchResult = res as? SearchResult, let fullTextResult = searchResult.fullTextResult {
            return String(fullTextResult.hitCount)
        }
        
        return nil
    }
    var body: some View {
        VStack {
            SearchBar(text: $search, onCommit: onCommit, onClear: onClear, onCancel: onCancel)
                .padding()
            HStack {
                Text("\"\(searched)\"")
                    .opacity(searched.isEmpty ? 0 : 1)
                Spacer()
                Text("\(results.count) találat")
                    .opacity(searched.isEmpty ? 0 : 1)
            }
            .font(.Theme.book(size: 17))
            .padding(.horizontal)
            resultList
                .overlay(overlay)
            Spacer()
        }
    }
    
    var resultList: some View {
        List {
            ForEach(results.indices, id:\.self) { index in
                resultRow(result: results[index])
                    .onTapGesture {
                        jumpToVers(result: results[index])
                    }
            }
        }
        .listStyle(.plain)
    }
    
    func jumpToVers(result: TextResult.Result) {
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
            Text("Nincs találat a(z) '\(search)' kifejezésre")
        }
    }
    
    func onClear() {
        search = ""
    }
    
    func onCommit() {
        searched = search
        vm.search(searchTerm: search)
    }
    
    func onCancel() {
        search = ""
        searched = ""
        vm.search(searchTerm: search)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(tabSelection: .constant(.search))
            .environmentObject(SearchViewModel.preview)
    }
}
