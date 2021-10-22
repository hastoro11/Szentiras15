//
//  SzentirasError.swift
//  SzentirasError
//
//  Created by Gabor Sornyei on 2021. 08. 08..
//

import Foundation

enum SzentirasError: Error, CustomStringConvertible {
    case badURL(String)
    case serverError
    case decodingError
    case badInput
    case unknown
    
    var description: String {
        switch self {
        case .badURL(let url):
            return "Bad URL: \(url)"
        case .serverError:
            return "Szerver hiba"
        case .decodingError:
            return "Decoding error"
        case .badInput:
            return "Error in input data"
        case .unknown:
            return "Unknown error"
        }
    }
}
