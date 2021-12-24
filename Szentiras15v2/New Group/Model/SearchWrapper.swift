//
//  SearchWrapper.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 21..
//

import Foundation

// MARK: - SearchWrapper
struct SearchWrapper: Codable {
    var fullTextResult: FullTextResult?
    
    var textResult: FullTextResult {
        fullTextResult ?? FullTextResult(results: [], hitCount: 0)
    }
}

// MARK: - FullTextResult
struct FullTextResult: Codable {
    var results: [Result]
    var hitCount: Int
    
    // MARK: - Result
    struct Result: Codable {
        var book: Book
        var verses: [Vers]

        // MARK: - Book
        struct Book: Codable {
            var number: Int
            var translationID: Int
            var name: String
            var abbrev: String
            
            enum CodingKeys: String, CodingKey {
                case number
                case translationID = "translation_id"
                case name, abbrev
            }
        }
        
        // MARK: - Vers
        struct Vers: Codable {
            var chapter: Int
            var numv: String
            var text: String
        }
                
    }
    
}

// MARK: - searchResults property
extension FullTextResult {
    var searchResults: [SearchResult] {
        var searchResults = [SearchResult]()
        for result in results {
            let searchResult = result.verses.map { vers -> SearchResult in
                SearchResult(
                    bookNumber: result.book.number,
                    translationID: result.book.translationID,
                    chapter: vers.chapter,
                    numv: Int(vers.numv) ?? 0,
                    text: vers.text)
            }
            searchResults += searchResult
        }
        return searchResults
    }
}

// MARK: - SearchResult
struct SearchResult {
    var bookNumber: Int
    var translationID: Int
    var chapter: Int
    var numv: Int
    var text: String
    
    var abbrev: String {
        "\(bookNumber)/\(chapter)/\(numv)/\(translationID)"
    }
    
    static var `default`: SearchResult {
        SearchResult(bookNumber: 101, translationID: 6, chapter: 1, numv: 1, text: "")
    }
}

