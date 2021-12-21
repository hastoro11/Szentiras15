//
//  SearchTest.swift
//  Szentiras15v2Tests
//
//  Created by Gabor Sornyei on 2021. 12. 21..
//

import XCTest
@testable import Szentiras15v2

class SearchTest: XCTestCase {

    func testDecode() throws {
        let url = Bundle.main.url(forResource: "SearchBuszke", withExtension: "json")!
        let data = try Data(contentsOf: url)
        XCTAssertNotNil(data)
        let searchWrapper = try JSONDecoder().decode(SearchWrapper.self, from: data)
        var total = 0
        
        for r in searchWrapper.fullTextResult.results {
            total += r.verses.count
        }
        print("total", total)
        print(searchWrapper.fullTextResult.searchResults.count)
        XCTAssertEqual(total, searchWrapper.fullTextResult.searchResults.count)
        XCTAssertNotNil(searchWrapper)
        print(searchWrapper.fullTextResult.searchResults[0].abbrev)
    }
}
