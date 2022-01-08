//
//  SearchVersListViewModel.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 24..
//

import SwiftUI

class SearchVersListViewModel: ObservableObject {
    @Published var phase: Phase = .empty
    @Published var idezet: Idezet = Idezet.default
    @Published var isLoading: Bool = false
    @Published var error: BibleError?
    @Published var translation: Translation?
    
    var searchResult: SearchResult
    
    init(searchResult: SearchResult) {
        self.searchResult = searchResult
        Task {
            await fetch()
        }
    }
    
    @MainActor
    func fetch() async {
        phase = .isLoading
        let translation = Translation.get(by: searchResult.translationID)
        let book = Book.get(by: searchResult.translationID, and: searchResult.bookNumber) ?? Book.default
        let chapter = searchResult.chapter
        do {
            self.idezet = try await NetworkService.shared.fetchIdezet(translation: translation.abbrev, book: book.abbrev, chapter: chapter)
            self.translation = translation
            phase = .success
        } catch {
            phase = .failure
            self.error = error as? BibleError ?? .unknown
            print("⛔️ SearchListViewModel - fetch()", error)
        }
    }
    
    // MARK: - Preview
    static var preview: SearchVersListViewModel {
        let model = SearchVersListViewModel(searchResult: TestData.searchResults[0])
        model.idezet = Idezet.example(filename: "Rom16")
        model.phase = .success
        return model
    }
}

