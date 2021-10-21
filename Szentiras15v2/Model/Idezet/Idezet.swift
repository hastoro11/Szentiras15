//
//  Idezet.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 21..
//

import Foundation

// MARK: - Idezet
struct Idezet: Codable {
    var keres: Keres
    var valasz: Valasz?
}

extension Idezet {
    static func example(filename: String) -> Idezet {
        let idezet: Idezet = Util.getItemFromBundle(filename: filename)
        return idezet
    }
}

// MARK: - Keres
struct Keres: Codable {
    var feladat, hivatkozas, forma: String
}

// MARK: - Valasz
struct Valasz: Codable {
    var apiVersek: [Vers]?
    var forditas: Forditas
    
    enum CodingKeys: String, CodingKey {
        case forditas
        case apiVersek = "versek"
    }
    
    var versek: [Vers] {
        apiVersek ?? []
    }
}

// MARK: - Forditas
struct Forditas: Codable {
    var nev, rov: String
}



