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
    case decoding
    case unknown
    
    var errorDescription: String {
        switch self {
        case .badURL:
            return "URL hiba"
        case .server:
            return "Szerverhiba"
        case .decoding:
            return "Adathiba"
        case .unknown:
            return "Ismeretlen hiba"
        }
    }
}
