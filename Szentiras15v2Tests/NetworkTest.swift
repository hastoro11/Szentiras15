//
//  NetworkTest.swift
//  Szentiras15v2Tests
//
//  Created by Gabor Sornyei on 2021. 12. 12..
//

import XCTest
@testable import Szentiras15v2

class NetworkTest: XCTestCase {

    func createURL(translation: Translation, book: Book, chapter: Int) -> URL? {
        var components = URLComponents(string: "https://szentiras.hu")
        let urlString = "/api/idezet/\(book.abbrev)\(chapter)/\(translation.abbrev)"
        components?.path = urlString
        return components?.url
    }
    
    func getIdezet(url: URL) async throws -> Idezet {
        let (data, _) = try await URLSession.shared.data(from: url)
        let idezet = try JSONDecoder().decode(Idezet.self, from: data)
        return idezet
    }
    
    func testNetwork() {
        let translation = Translation.default
        let book = Book.default
        let chapter = 1
        let url = createURL(translation: translation, book: book, chapter: chapter)
        XCTAssertNotNil(url)
        Task {
            let idezet = try await getIdezet(url: url!)
            XCTAssertNotNil(idezet)
            XCTAssertTrue(!idezet.valasz.versek.isEmpty)
        }
    }
    
    func testAll() async throws {
        let translation = Translation.get(by: 1)
        for book in translation.getBooks() {
            print("📖 testing book...")
            for ch in 1...book.chapters {
                let url = createURL(translation: translation, book: book, chapter: ch)
                XCTAssertNotNil(url)
                
                let idezet = try await getIdezet(url: url!)
                print("🐧 -> testing idezet", translation.abbrev, book.abbrev, ch)
                for vers in idezet.valasz.versek {
                    XCTAssertTrue(vers.hely.gepi != 0)
                }
                
            }
        }
        
    }
    
//    func testGenerateURL() async throws {
//        let service = NetworkService.shared
//        
//        let url = service.generateIdezetURL(translation: "SZIT", book: "1Móz", chapter: 2)
//        XCTAssertNotNil(url)
//        print("😀", url!)
//        let idezet = try await getIdezet(url: url!)
//        XCTAssertNotNil(idezet)
//        print("🐧 => Idezet ->", idezet.keres)
//        
//    }
    
}
