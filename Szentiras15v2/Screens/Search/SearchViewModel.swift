//
//  SearchViewModel.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 24..
//

import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var phase: FetchPhase = .isFetching    
    init() {
        
    }
    
    func search(searchTerm: String) {
        Task {
            await fetch(searchTerm: searchTerm)
        }
    }
    
    @MainActor
    private func fetch(searchTerm: String) async {
        phase = .isFetching
        do {
            let searchResult = try await SzentirasAPI.instance.search(searchTerm)
            if Task.isCancelled { return }
            phase = .success(searchResult)
        } catch {
            print("⛔️ Error in 'SearchViewModel.fetch()' - ", error)
            if Task.isCancelled { return }
            phase = .error(error as? SzentirasError ?? .unknown)
        }
    }
    
    static var preview: SearchViewModel {
        let vm = SearchViewModel()
        let result: SearchResult = Util.getItemFromBundle(filename: "SearchBuszke")
        vm.phase = .success(result)
        return vm
    }
}
