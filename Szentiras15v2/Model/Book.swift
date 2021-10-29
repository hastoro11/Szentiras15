//
//  Book.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 21..
//

import Foundation
import UIKit

// MARK: - Book

struct Book : Codable, Identifiable {
    var id: Int {
        number
    }
    var abbrev : String
    var chapters : Int
    var name : String
    var number : Int
    
    enum CodingKeys: String, CodingKey {
        case abbrev = "abbrev"
        case chapters = "chapters"
        case name = "name"
        case number = "number"
    }
}

extension Book {
    static func all(by translationID: Int) -> [Book] {
        let booksInTranslation: [BooksInTranslation] = Util.getItemFromBundle(filename: "books")
        return booksInTranslation.first { $0.translation.id == translationID }?.books ?? []
    }
    
    static var combined: [Book] {
        let basic = Self.all(by: 6)
        let catholic = Self.all(by: 1).filter {
            $0.number == 117 || $0.number == 118 || $0.number == 125 || $0.number == 126 || $0.number == 130 || $0.number == 145 || $0.number == 146
        }
        return (basic+catholic).sorted(by: {$0.number < $1.number})
    }
    
    static func get(by translationID: Int, and bookNumber: Int) -> Book? {
        let books = Self.all(by: translationID)
        
        return books.first { $0.number == bookNumber }
    }
}

extension Book {
    static var `default`: Book {
        Book.all(by: 6)[0]
    }
}

struct BooksInTranslation: Codable {
    struct Translation: Codable {
        var abbrev: String
        var id: Int
    }
    var translation: Translation
    var books: [Book]
}
