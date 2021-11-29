//
//  BookTest.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 28..
//

import XCTest
@testable import Szentiras15v2

class BookTest: XCTestCase {
    
    func testAllBook() {
        for translationID in 1...6 {
            let books = Book.all(by: translationID)
            if translationID == 1 || translationID == 3 {
                XCTAssertEqual(books.count, 73)
            } else if translationID == 5 || translationID == 7 {
                XCTAssertEqual(books.count, 27)
            } else {
                XCTAssertEqual(books.count, 66)
            }
        }     
    }
    
    func testGetBook() {
        var translationID = 1
        var bookID = 101
        var book = Book.get(by: translationID, and: bookID)
        XCTAssertNotNil(book)
        XCTAssertEqual(book!.abbrev, "Ter")
        
        bookID = 146
        book = Book.get(by: translationID, and: bookID)
        XCTAssertNotNil(book)
        XCTAssertEqual(book!.abbrev, "2Mak")
        
        translationID = 2
        book = Book.get(by: translationID, and: bookID)
        XCTAssertNil(book)
        
        bookID = 227
        book = Book.get(by: translationID, and: bookID)
        XCTAssertEqual(book!.abbrev, "Jel")
        
        translationID = 8
        book = Book.get(by: translationID, and: bookID)
        XCTAssertNil(book)
    }

    func testGetBooksByCategories() {
        
        for i in 1...7 {
            let translation = Translation.get(by: i)
            
            let categories = Book.getBooksByCategories(byTranslationID: i)
            if translation.id == 1 || translation.id == 3 {
                XCTAssertEqual(categories[0].books.count, 5)
                XCTAssertEqual(categories[1].books.count, 14)
                XCTAssertEqual(categories[2].books.count, 6)
                XCTAssertEqual(categories[3].books.count, 21)
                
                XCTAssertEqual(categories[0].books[0].number, 101)
            } else if translation.id == 2 || translation.id == 4 || translation.id == 6 {
                XCTAssertEqual(categories[0].books.count, 5)
                XCTAssertEqual(categories[1].books.count, 12)
                XCTAssertEqual(categories[2].books.count, 5)
                XCTAssertEqual(categories[3].books.count, 17)
                
                XCTAssertEqual(categories[0].books[0].abbrev, "1Móz")
            } else {
                XCTAssertEqual(categories[0].books.count, 4)
                XCTAssertEqual(categories[1].books.count, 1)
                XCTAssertEqual(categories[2].books.count, 21)
                XCTAssertEqual(categories[3].books.count, 1)
            }
            XCTAssertNotNil(categories.last?.books.last)
            XCTAssertEqual(categories.last!.books.last!.id, 227)
        }
    }
}
