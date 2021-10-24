//
//  SearchResult.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 24..
//

import Foundation

struct SearchResult : Codable {
    
    var fullTextResult : FullTextResult?
    
    enum CodingKeys: String, CodingKey {
        case fullTextResult = "fullTextResult"
    }
}

struct FullTextResult : Codable {
    
    var hitCount : Int
    private var apiResults : [TextResult]?
    
    enum CodingKeys: String, CodingKey {
        case hitCount = "hitCount"
        case apiResults = "results"
    }
    
    var results: [TextResult] {
        apiResults ?? []
    }
}

struct TextResult : Codable {
    
    var book : TextResult.Book
    var translation : TextResult.Translation
    private var verses : [SearchVers]?
    
    enum CodingKeys: String, CodingKey {
        case book = "book"
        case translation = "translation"
        case verses = "verses"
    }
    
    struct Book: Codable {
        var abbrev : String
        var id : Int
        var name : String
        var number : Int
        var oldTestament : Int
        var translationId : Int
        
        enum CodingKeys: String, CodingKey {
            case abbrev = "abbrev"
            case id = "id"
            case name = "name"
            case number = "number"
            case oldTestament = "old_testament"
            case translationId = "translation_id"
        }
    }
    
    struct Translation: Codable {
        var abbrev : String
        var denom : String
        var id : Int
        var name : String
        
        enum CodingKeys: String, CodingKey {
            case abbrev = "abbrev"
            case denom = "denom"
            case id = "id"
            case name = "name"
        }
    }
    
    struct Result: Codable {
        var book: TextResult.Book
        var translation: Translation
        var chapter: String
        var numv: String
        var text: String
        var abbrev: String
        
    }
    
    var results: [Result] {
        var results = [Result]()
        guard let verses = verses else { return [] }
        results = verses.compactMap { vers -> Result in
            Result(
                book: book,
                translation: translation,
                chapter: String(vers.chapter),
                numv: vers.numv,
                text: vers.text,
                abbrev: "\(book.abbrev)/\(vers.chapter)/\(vers.numv)/\(translation.abbrev.uppercased())"
            )
        }
        return results
    }
}

struct SearchVers : Codable {
    
    var chapter : Int
    var numv : String
    var text : String
    
    enum CodingKeys: String, CodingKey {
        case chapter = "chapter"
        case numv = "numv"
        case text = "text"
    }
}

