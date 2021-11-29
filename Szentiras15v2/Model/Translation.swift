//
//  Translation.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 21..
//

import Foundation

// MARK: - Translation

struct Translation : Codable, Identifiable {
    
    var abbrev : String
    var copyright : String
    var createdAt : String
    var denom : String
    var id : Int
    var lang : String
    var name : String
    var order : Int
    var publisher : String
    var publisherUrl : String
    var reference : String
    var updatedAt : String
    
    enum CodingKeys: String, CodingKey {
        case abbrev = "abbrev"
        case copyright = "copyright"
        case createdAt = "created_at"
        case denom = "denom"
        case id = "id"
        case lang = "lang"
        case name = "name"
        case order = "order"
        case publisher = "publisher"
        case publisherUrl = "publisher_url"
        case reference = "reference"
        case updatedAt = "updated_at"
    }
}

extension Translation {
    static func all() -> [Translation] {
        let translations: [Translation] = Util.getItemFromBundle(filename: "translations")
        return translations
    }
    
    static func get(by translationID: Int) -> Translation {
        let translations: [Translation] = Util.getItemFromBundle(filename: "translations")
        return translations.first { $0.id == translationID }!
    }
}

extension Translation {
    static var `default`: Translation {
        Translation.get(by: 6)
    }
    
    func getBooks() -> [Book] {
        Book.all(by: self.id)
    }
}
