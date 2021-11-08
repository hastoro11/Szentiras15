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
    
    func add(current: Current) {
        let capacity = UserDefaults.standard.historyCapacity
        var historyList = fetch()
        if historyList.count >= capacity {
            historyList = Array(historyList.prefix(capacity-1))
        }
        if let index = historyList.firstIndex(of: current) {
            historyList.remove(at: index)
        }
        historyList.insert(current, at: 0)
        persist(history: historyList)
    }
    
    func fetch() -> [Current] {
        do {
            guard let data = UserDefaults.standard.data(forKey: "history") else {
                return []
            }
            let historyList = try PropertyListDecoder().decode([Current].self, from: data)
            return historyList
        } catch {
            print("⛔️ HistoryService - error in 'fetch'", error)
            return []
        }
        
    }
    
    func remove(_ current: Current) {
        var historyList = fetch()
        if let index = historyList.firstIndex(of: current) {
            historyList.remove(at: index)
        }
        persist(history: historyList)
    }
    
    func persist(history: [Current]) {
        do {
            let data = try PropertyListEncoder().encode(history)
            UserDefaults.standard.set(data, forKey: "history")
        } catch {
            print("⛔️ HistoryService -error in 'persist'", error)
        }
    }
}
