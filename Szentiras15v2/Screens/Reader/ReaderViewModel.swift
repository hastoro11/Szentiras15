//
//  ReaderViewModel.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 21..
//

import SwiftUI

struct Current {
    var translation: Translation
    var book: Book
    var chapter: Int
    
    var chapters: Int {
        book.chapters
    }
}

enum FetchPhase {
    case success(Idezet)
    case error(SzentirasError)
    case isFetching
    case empty
}


class ReaderViewModel: ObservableObject {
    @Published var phase: FetchPhase = .isFetching
    var current: Current
    
    init() {
        current = Current(
            translation: Translation.default,
            book: Book.default,
            chapter: 1)
    }
    
    func load(current: Current) {
        self.current = current
        Task {
            await fetch()
        }
    }
    
    @MainActor
    func fetch() async {
        do {
            let idezet = try await SzentirasAPI.instance.fetch(current)
            if Task.isCancelled { return }
            self.phase = .success(idezet)
        } catch {
            if Task.isCancelled { return }
            print("⛔️ Error in ReaderViewModel 'fetch' - ", error)
        }
    }
}

extension ReaderViewModel {
    static var preview: ReaderViewModel {
        let vm = ReaderViewModel()
        let idezet = Idezet.example(filename: "Rom16")
        vm.phase = .success(idezet)
        return vm
    }
}
