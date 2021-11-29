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
    struct Category {
        var id: Int
        var title: String
        var books: [Book]
    }
    
    static func getBooksByCategories(byTranslationID: Int) -> [Category] {
        let translation = Translation.get(by: byTranslationID)
        let isCatholic = translation.denom == "katolikus"
        var categories = [
            Category(
                id: 0,
                title: "A Törvény könyvei",
                books: getBookByNumbers(numbers: Array(101...105), translationID: byTranslationID)),
            Category(
                id: 1,
                title: "Ószövetségi történelmi könyvek",
                books: isCatholic ? getBookByNumbers(numbers: Array(106...119), translationID: byTranslationID) : getBookByNumbers(numbers: Array(106...119), translationID: byTranslationID)
            ),
            Category(
                id: 2,
                title: "Költői könyvek",
                books: isCatholic ? getBookByNumbers(numbers: Array(120...125), translationID: byTranslationID) : getBookByNumbers(numbers: Array(120...124), translationID: byTranslationID)
            ),
            Category(
                id: 3,
                title: "Ószövetség prófétai könyvek",
                books: isCatholic ? getBookByNumbers(numbers: Array(126...146), translationID: byTranslationID) : getBookByNumbers(numbers: Array(126...144), translationID: byTranslationID)
            ),
            Category(
                id: 4,
                title: "Evangéliumok",
                books: getBookByNumbers(numbers: Array(201...204), translationID: byTranslationID)
            ),
            Category(
                id: 5,
                title: "Újszövetség történelmi könyvek",
                books: getBookByNumbers(numbers: [205], translationID: byTranslationID)
            ),
            Category(
                id: 6,
                title: "Levelek",
                books: getBookByNumbers(numbers: Array(206...226), translationID: byTranslationID)
            ),
            Category(
                id: 7,
                title: "Újszövetség prófétai könyvek",
                books: getBookByNumbers(numbers: [227], translationID: byTranslationID)
            ),
        ]
        
        if translation.id == 5 || translation.id == 7 {
            categories = categories.filter({$0.id >= 4})
        }
        
        return categories
    }
    
    private static func getBookByNumbers(numbers: [Int], translationID: Int) -> [Book] {
        let books = Translation.get(by: translationID).getBooks()
        return books.filter({numbers.contains($0.number)})
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
