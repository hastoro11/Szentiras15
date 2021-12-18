//
//  NetworkService.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 18..
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchIdezet(translation: String, book: String, chapter: Int) async throws -> Idezet
}

struct NetworkService: NetworkServiceProtocol {
    private init() {}
    static var shared = NetworkService()
    
    func fetchIdezet(translation: String, book: String, chapter: Int) async throws -> Idezet {
        let url = generateIdezetURL(translation: translation, book: book, chapter: chapter)
        guard let url = url else { return Idezet.default }
        return try await fetch(url: url)
    }
    
    private func fetch<T: Codable>(url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
            throw BibleError.server
        }
        if data.isEmpty {
            throw BibleError.server
        }
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            print(error)
            throw BibleError.decoding
        }
    }
    
    private func generateIdezetURL(translation: String, book: String, chapter: Int) -> URL? {
        var components = URLComponents(string: "https://szentiras.hu")
        let path = "/api/idezet/\(book)\(chapter)/\(translation)"
        components?.path = path
        
        return components?.url
    }
}
