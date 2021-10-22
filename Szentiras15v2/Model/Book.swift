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
