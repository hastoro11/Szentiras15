//
//  UtilTest.swift
//  Szentiras15v2Tests
//
//  Created by Gabor Sornyei on 2021. 11. 30..
//

import XCTest
@testable import Szentiras15v2

class UtilTest: XCTestCase {

    func testGetItemFromBundle() {
        let url = Bundle.main.url(forResource: "SearchBuszke", withExtension: "json")!
        let data = try? Data(contentsOf: url)
        XCTAssertNotNil(data)
        let searchResult = try? JSONDecoder().decode(SearchResultWrapper.self, from: data!)
        XCTAssertNotNil(searchResult)
        XCTAssertNotNil(searchResult!.fullTextResult!)
        XCTAssertFalse(searchResult!.fullTextResult!.results.isEmpty)
    }

    func testUtilGetItemFromBundle() {
        let searchResult: SearchResultWrapper = Util.getItemFromBundle(filename: "SearchBuszke")
        XCTAssertNotNil(searchResult)
        XCTAssertNotNil(searchResult.fullTextResult!)
        XCTAssertFalse(searchResult.fullTextResult!.results.isEmpty)
    }
}
