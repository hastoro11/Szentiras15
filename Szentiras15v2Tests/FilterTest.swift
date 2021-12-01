//
//  FilterTest.swift
//  Szentiras15v2Tests
//
//  Created by Gabor Sornyei on 2021. 12. 01..
//

import XCTest
@testable import Szentiras15v2


class FilterTest: XCTestCase {

    func testFilter() {
        for t in SearchFilter.Testament.allCases {
            XCTAssertNotNil(t)
        }
    }
}
