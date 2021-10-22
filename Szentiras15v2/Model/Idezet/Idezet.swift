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
    var valasz: Valasz
}

extension Idezet {
    static func example(filename: String) -> Idezet {
        let idezet: Idezet = Util.getItemFromBundle(filename: filename)
        return idezet
    }
}

extension Idezet {
    static var `default`: Idezet {
        Idezet(
            keres: Keres(feladat: "", hivatkozas: "", forma: ""),
            valasz: Valasz.default
        )
    }
}

// MARK: - Keres
struct Keres: Codable {
    var feladat, hivatkozas, forma: String
}

// MARK: - Valasz
struct Valasz: Codable {
    private var apiVersek: [Vers]?
    var forditas: Forditas
    
    enum CodingKeys: String, CodingKey {
        case forditas
        case apiVersek = "versek"
    }
    
    var versek: [Vers] {
        apiVersek ?? []
    }
}

extension Valasz {
    static var `default`: Valasz {
        Valasz(
            apiVersek: [],
            forditas: Forditas(nev: "", rov: "")
        )
    }
}

// MARK: - Forditas
struct Forditas: Codable {
    var nev, rov: String
}



