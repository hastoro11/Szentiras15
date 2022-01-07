//
//  Extensions.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2022. 01. 06..
//

import SwiftUI

// MARK: - View
extension View {
    @ViewBuilder
    func isLoading(isLoading: Bool) -> some View {
        self.redacted(reason: isLoading ? .placeholder : [])
            .overlay(
                ProgressView("Keresés...")
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8.0))
                    .opacity(isLoading ? 1.0 : 0)
            )
        
    }
}

// MARK: - String
extension String {
    var htmlString: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

// MARK: - UserDefaults
extension UserDefaults {
    
    // MARK: History
    var historyCapacity: Int {
        let capacity = self.integer(forKey: "historyCapacity")
        if capacity == 0 {
            return 10
        }
        
        return capacity
    }
    
    func setHistoryCapacity(to newCapacity: Int) {
        self.set(newCapacity, forKey: "historyCapacity")
    }
    
    func saveCurrent(current: Current) {
        self.set(current.translation.id, forKey: "translationID")
        self.set(current.book.number, forKey: "bookNumber")
        self.set(current.chapter, forKey: "chapter")
    }
    
    var savedCurrent: Current {
        let translationID = self.integer(forKey: "translationID") == 0 ? 6 : self.integer(forKey: "translationID")
        let bookNumber = self.integer(forKey: "bookNumber") == 0 ? 101 : self.integer(forKey: "bookNumber")
        let chapter = self.integer(forKey: "chapter") == 0 ? 1 : self.integer(forKey: "chapter")
        
        let translation = Translation.get(by: translationID)
        let book = Book.get(by: translation.id, and: bookNumber) ?? Book.default
        
        let current = Current(translation: translation, book: book, chapter: chapter)
        
        return current
    }
    
    var isCurrentSaved: Bool {
        self.bool(forKey: "isCurrentSaved")
    }
    
    func setCurrentSaved(value: Bool) {
        self.set(value, forKey: "isCurrentSaved")
    }
}
