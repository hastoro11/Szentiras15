//
//  SearchView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 23..
//

import SwiftUI

struct SearchView: View {
    @StateObject var vm: SearchViewModel = SearchViewModel.preview
    @State var search: String = ""
    var results: [TextResult.Result] {
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
            SearchBar(text: $search, onCommit: onCommit, onClear: onClear)
                .padding()
            Text("\(hitCount ?? "") találat")
                .opacity(hitCount == nil ? 0 : 1)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal)
            resultList
            Spacer()
        }
        .onAppear {
            vm.search(searchTerm: "szekér")
        }
    }
    
    var resultList: some View {
        List { 
            ForEach(results.indices, id:\.self) { index in
                resultRow(result: results[index])
            }
        }
        .listStyle(.plain)
    }
    
    func resultRow(result: TextResult.Result) -> some View {
        VStack(alignment: .leading) {
            Text("\(result.book.abbrev) \(result.chapter),\(result.numv)")
                .font(.Theme.heavy(size: 19))
            Text(result.translation.name)
                .font(.Theme.heavy(size: 17))
            Text(result.text)
                .font(.Theme.book(size: 17))
                .lineLimit(2)
        }
    }
    
    func onClear() {
        print("onClear")
    }
    
    func onCommit() {
        print("Search:", search)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
