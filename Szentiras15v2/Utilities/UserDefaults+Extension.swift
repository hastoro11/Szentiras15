//
//  UserDefaults+Extension.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 03..
//

import Foundation

extension UserDefaults {
    func saveFontSize(fontSize: Double) {
        self.set(fontSize, forKey: "fontSize")
    }
    
    var getFontSize: Double {
        let size = self.double(forKey: "fontSize")
        if size == 0 {
            return 17
        }
        
        return size
    }
    
    func setFontSizeSaved(value: Bool) {
        self.set(value, forKey: "isFontSizeSaved")
    }
    
    var isFontSizeSaved: Bool {
        self.bool(forKey: "isFontSizeSaved")
    }
    
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
