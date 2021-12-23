//
//  BibleController.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 12..
//

import Foundation

enum Phase {
    case empty
    case isLoading
    case failure
    case success
}

class BibleController: ObservableObject {
    
    
    @Published var phase: Phase = .empty
    
    @Published var idezet: Idezet = Idezet.default
    @Published var error: BibleError?
    
    var history: [Current]
    var historySize: Int
    var current: Current
    
    init() {
        current = Current(translation: Translation.default, book: Book.default, chapter: 1)
        idezet = Idezet.default
        historySize = 5
        history = []
        Task {
            await fetch()
        }
    }
    
    func changeTranslation(to translationID: Int) {
        let translation = Translation.get(by: translationID)
        current.translation = translation
    }
    
    @MainActor
    func fetch() async {
        phase = .isLoading
        do {
            let idezet = try await NetworkService.shared.fetchIdezetWithRequest(
                translation: current.translation.abbrev.uppercased(),
                book: current.book.abbrev,
                chapter: current.chapter)
            if Task.isCancelled { return }
            phase = .success
            self.idezet = idezet
            addToHistory()
        } catch {
            print("⛔️ BibleController - fetch()", error)
            if Task.isCancelled { return }
            phase = .failure
            self.error = error as? BibleError ?? .unknown
        }        
    }
    
    func deleteAllHistory() {
        history = []
    }
    
    private func addToHistory() {
        if history.contains(self.current) {
            history = history.filter { $0 != self.current}
        }
        history.insert(self.current, at: 0)
        history = Array(history.prefix(historySize))
    }
    
    // MARK: - Preview
    static var preview: BibleController {
        let controller = BibleController()
        controller.phase = .success
        controller.error = BibleError.server
        controller.idezet = Idezet.example(filename: "1Sam17")
        return controller
    }
}
