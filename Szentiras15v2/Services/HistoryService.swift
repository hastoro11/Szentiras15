//
//  HistoryService.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 31..
//

import Foundation

struct HistoryService {
    static var instance: HistoryService = HistoryService()
    private init() {}
    
    private var historyList: [Current] = [
        Current(translation: Translation.get(by: 1)!, book: Book.get(by: 1, and: 101)!, chapter: 1),
        Current(translation: Translation.get(by: 2)!, book: Book.get(by: 2, and: 111)!, chapter: 2),
        Current(translation: Translation.get(by: 3)!, book: Book.get(by: 3, and: 121)!, chapter: 3),
        Current(translation: Translation.get(by: 4)!, book: Book.get(by: 4, and: 201)!, chapter: 10),
        Current(translation: Translation.get(by: 5)!, book: Book.get(by: 5, and: 211)!, chapter: 4),
        Current(translation: Translation.get(by: 6)!, book: Book.get(by: 6, and: 221)!, chapter: 2),
        Current(translation: Translation.get(by: 2)!, book: Book.get(by: 2, and: 210)!, chapter: 1)
    ]
    
    var history: [Current] {
        historyList
    }
    
    static var preview: HistoryService {
        var service = HistoryService.init()
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
