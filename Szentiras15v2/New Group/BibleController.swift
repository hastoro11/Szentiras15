//
//  BibleController.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 12..
//

import Foundation

class BibleController: ObservableObject {
    
    enum Phase {
        case empty
        case isLoading
        case failure
        case success
    }
    
    @Published var phase: Phase = .empty
    
    @Published var idezet: Idezet = Idezet.default
    @Published var error: BibleError?
    
    var current: Current
    
    init() {
        current = Current(translation: Translation.default, book: Book.default, chapter: 1)
        idezet = Idezet.default
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
        } catch {
            print("⛔️ BibleController - fetch()", error)
            if Task.isCancelled { return }
            phase = .failure
            self.error = error as? BibleError ?? .unknown
        }        
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
