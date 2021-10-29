//
//  Cache.swift
//  Szentiras15
//
//  Created by Gabor Sornyei on 2021. 09. 21..
//

import Foundation
import SwiftUI

class Cache<Value> where Value: Codable {
    
    class Entry<Value>: Codable where Value: Codable {
        var key: String
        var value: Value
        var expirationDate: Date
        init(key: String, value: Value, expirationDate: Date) {
            self.key = key
            self.value = value
            self.expirationDate = expirationDate
        }
    }
    
    private var wrapped: NSCache<NSString, Entry> = NSCache<NSString, Entry<Value>>()
    private var expirationInterval: TimeInterval
    private var maxEntryCount: Int
    
    init(expirationInterval: TimeInterval = 30 * 60, maxEntryCount: Int = 50) {
        print(FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0])
        self.expirationInterval = expirationInterval
        self.maxEntryCount = maxEntryCount
    }
}

extension Cache {
    private var cacheUrl: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("entries.json")
    }
    private func insert(key: String, value: Value) {
        let entry = Entry(key: key, value: value, expirationDate: .now + expirationInterval)
        wrapped.setObject(entry, forKey: NSString(string: key))
        persist(entry: entry)
    }
    
    private func persist(entry: Entry<Value>) {
        var dict = loadFromCache()
        if dict.count >= maxEntryCount {
            removeOldestEntryFromCache()
        }
        dict = loadFromCache()
        dict[entry.key] = entry
        let data = try? JSONEncoder().encode(dict)
        try? data?.write(to: cacheUrl)
    }
    
    private func removeOldestEntryFromCache() {
        var dict = loadFromCache()
        if let minEntry = dict.values.min(by: {$0.expirationDate < $1.expirationDate}) {
            dict.removeValue(forKey: minEntry.key)
        }
        let data = try? JSONEncoder().encode(dict)
        try? data?.write(to: cacheUrl)
    }
    
    private func loadFromCache() -> [String: Entry<Value>] {
        let data = try? Data(contentsOf: cacheUrl)
        if let data = data {
            let dict = try? JSONDecoder().decode([String: Entry<Value>].self, from: data)
            return dict ?? [:]
        }
        return [:]
    }
    
    private func value(key: String) -> Entry<Value>? {
        if let entry = wrapped.object(forKey: NSString(string: key)) {
            if entry.expirationDate > .now {
                wrapped.removeObject(forKey: NSString(string: key))
                return entry
            }
            return nil
        }
        let dict = loadFromCache()
        if let entry = dict[key] {
            return entry
        }
        
        return nil
    }
}

extension Cache {
    subscript(key: String) -> Value? {
        get {
            guard let object = value(key: key) else {
                return nil
            }            
            return object.value
        }
        set {
            guard let value = newValue else {
                wrapped.removeObject(forKey: NSString(string: key))
                return
            }
            insert(key: key, value: value)
        }
    }
}
