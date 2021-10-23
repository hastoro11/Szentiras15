//
//  SzentirasAPI.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 21..
//

import SwiftUI

class SzentirasAPI {
    static var instance: SzentirasAPI = SzentirasAPI()
    private init(){}
    
    func fetch(_ current: Current) async throws -> Idezet {
        let url = buildURL(translation: current.translation, book: current.book, chapter: current.chapter)
//        let url = URL(string: "https://szentiras.hu/api/idezet/23232/sdfsdfsdf")!
        let idezet: Idezet = try await fetch(from: url)
        return idezet
    }
    
    private func fetch<T: Codable>(from url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
            throw SzentirasError.serverError
        }
        if data.isEmpty {
            throw SzentirasError.serverError
        }
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            if let _ = error as? SzentirasError {
                print("⛔️ Error in API fetch - ", error)
                throw SzentirasError.unknown
            }
            print("⛔️ Error in API fetch - ", error)
            throw SzentirasError.decodingError
        }
    }
    
    private func buildURL(translation: Translation, book: Book, chapter: Int) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "szentiras.hu"
        urlComponents.path = "/api/idezet/\(book.abbrev)\(chapter)/\(translation.abbrev)".removingPercentEncoding ?? "api/idezet/\(book.abbrev)\(chapter)/\(translation.abbrev)"
        return urlComponents.url!
    }
}
