//
//  BibleError.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 18..
//

import Foundation

enum BibleError: Error {
    case badURL
    case server
    case data
    case decoding
    case unknown
    
    var errorDescription: String {
        switch self {
        case .badURL:
            return "URL hiba"
        case .server:
            return "Szerverhiba"
        case .data:
            return "Adathiba"
        case .decoding:
            return "Dekódolás hiba"
        case .unknown:
            return "Ismeretlen hiba"
        }
    }
}
