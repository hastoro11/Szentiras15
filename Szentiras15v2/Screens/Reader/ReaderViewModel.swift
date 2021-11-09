//
//  ReaderViewModel.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 21..
//

import SwiftUI

struct Current: Codable, Equatable {
    static func == (lhs: Current, rhs: Current) -> Bool {
        lhs.key == rhs.key
    }
    
    var translation: Translation
    var book: Book
    var chapter: Int
    
    var chapters: Int {
        book.chapters
    }
    
    var key: String {
        "\(book.abbrev)/\(chapter)/\(translation.abbrev.uppercased())"
    }
}

enum FetchPhase {
    case success(Codable)
    case error(SzentirasError)
    case isFetching
    case empty
}

class ReaderViewModel: ObservableObject {
    @Published var phase: FetchPhase = .isFetching
    
    var current: Current
    
    var cache = Cache<Idezet>()
    
    var seekSearched: Bool = false
    var searchTag: String = ""
    
    init() {
        if UserDefaults.standard.isCurrentSaved {
            current = UserDefaults.standard.savedCurrent
        } else {
            current = Current(
                translation: Translation.default,
                book: Book.default,
                chapter: 1)
        }
    }
    
    func load() {
        load(current: self.current)
    }
    
    func load(current: Current) {
        self.current = current
        if UserDefaults.standard.isCurrentSaved {
            UserDefaults.standard.saveCurrent(current: current)
        }
        HistoryService.instance.add(current: current)
        if let saved = cache[current.key] {
            if saved.valasz.versek.isEmpty {
                HistoryService.instance.remove(current)
            }
            self.phase = .success(saved)            
            return
        }
        if Task.isCancelled { return }
        Task {
            await fetch()
        }
    }
    
    @MainActor
    func fetch() async {
        phase = .isFetching
        do {
            let idezet = try await SzentirasAPI.instance.fetch(current)
            if Task.isCancelled { return }
            if idezet.valasz.versek.isEmpty {
                self.phase = .empty
                HistoryService.instance.remove(current)
            } else {
                self.phase = .success(idezet)
                cache[current.key] = idezet
            }
        } catch {
            if Task.isCancelled { return }
            HistoryService.instance.remove(current)
            print("⛔️ Error in ReaderViewModel 'fetch' - ", error)
            self.phase = .error(error as? SzentirasError ?? .unknown)
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
