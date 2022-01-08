//
//  SearchController.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 22..
//

import SwiftUI

class SearchController: ObservableObject {
    
    @Published var searchResults: [SearchResult] = []
    @Published var phase: Phase = .empty
    @Published var error: BibleError?
    var searchTerm: String = ""
    
    @MainActor
    func fetch(searchTerm: String) async {
        phase = .isLoading
        do {
        let results = try await NetworkService.shared.fetchSearchWithRequest(searchTerm: searchTerm)
            self.searchResults = results
            phase = .success
        } catch {
            print("⛔️ SearchController - fetch()", error)
            self.error = error as? BibleError ?? .unknown
            phase = .failure
        }
    }
    
    func resetSearchResults() {
        phase = .empty
        searchResults = []
    }
    
    // MARK: - Preview
    static var preview: SearchController {
        let controller = SearchController()
        controller.phase = .success
        controller.searchResults = TestData.searchResults
        return controller
    }
}
