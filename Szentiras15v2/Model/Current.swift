//
//  Current.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2022. 01. 08..
//

import SwiftUI


struct Current: Codable, Equatable {
    static func == (lhs: Current, rhs: Current) -> Bool {
        lhs.key == rhs.key
    }
    
    var translation: Translation
    var book: Book
    var chapter: Int
    
    var chapters: Int {
        book.chapters
    }
    
    var key: String {
        "\(book.abbrev)/\(chapter)/\(translation.abbrev.uppercased())"
    }
   
}
