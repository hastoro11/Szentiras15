//
//  HistoryViewModel.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 31..
//

import Foundation

class HistoryViewModel: ObservableObject {
    @Published var historyList: [Current]
    var capacity: Int
    
    init() {
        historyList = HistoryService.instance.fetch()
        capacity = UserDefaults.standard.historyCapacity
        historyList = Array(historyList.prefix(capacity))
    }
    
    @MainActor
    func fetch() {
        historyList = HistoryService.instance.fetch()
    }
    
    func removeFromHistory(_ index: Int) {
        historyList.remove(at: index)
        HistoryService.instance.persist(history: historyList)
    }
    
    func removeAllHistory() {
        historyList = []
        HistoryService.instance.persist(history: historyList)
    }
    
    static var preview: HistoryViewModel {
        let service = HistoryViewModel.init()
        service.historyList = [
            Current(translation: Translation.get(by: 1)!, book: Book.get(by: 1, and: 101)!, chapter: 1),
            Current(translation: Translation.get(by: 2)!, book: Book.get(by: 2, and: 111)!, chapter: 2),
            Current(translation: Translation.get(by: 3)!, book: Book.get(by: 3, and: 121)!, chapter: 3),
            Current(translation: Translation.get(by: 4)!, book: Book.get(by: 4, and: 201)!, chapter: 10),
            Current(translation: Translation.get(by: 5)!, book: Book.get(by: 5, and: 211)!, chapter: 4),
            Current(translation: Translation.get(by: 6)!, book: Book.get(by: 6, and: 221)!, chapter: 2),
            Current(translation: Translation.get(by: 2)!, book: Book.get(by: 2, and: 210)!, chapter: 1)
        ]
        return service
    }
    
}
