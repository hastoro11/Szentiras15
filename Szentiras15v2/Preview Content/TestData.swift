//
//  TestData.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 27..
//

import Foundation

struct TestData {
    static var idezetRom16: Idezet {
        let idezet: Idezet = Util.getItemFromBundle(filename: "Rom16")
        return idezet
    }
    static var idezet1Sam17: Idezet {
        let idezet: Idezet = Util.getItemFromBundle(filename: "1Sam17")
        return idezet
    }
    
    static var current: Current {
        Current(
            translation: Translation.default,
            book: Book.default,
            chapter: 1)
    }
}
