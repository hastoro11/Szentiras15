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
    private init() {
        cache = URLCache(
            memoryCapacity: 1024 * 1024 * 5,
            diskCapacity: 1024 * 1024 * 20)
    }
    static var shared = NetworkService()
    private var cache: URLCache
    
    func fetchIdezet(translation: String, book: String, chapter: Int) async throws -> Idezet {
        let url = generateIdezetURL(translation: translation, book: book, chapter: chapter)
        guard let url = url else { return Idezet.default }
        return try await fetch(url: url)
    }
    
    func fetchIdezetWithRequest(translation: String, book: String, chapter: Int) async throws -> Idezet {
        let request = generateIdezetURLRequest(translation: translation, book: book, chapter: chapter)
        guard let request = request else { return Idezet.default }
        return try await fetch(request: request)
    }
    
    private func fetch<T: Codable>(request: URLRequest) async throws -> T {
        var data: Data
        var response: URLResponse
        if let cachedResponse = cache.cachedResponse(for: request) {
            data = cachedResponse.data
            response = cachedResponse.response
            if let resp = response as? HTTPURLResponse, !(200...299).contains(resp.statusCode) {
                (data, response) = try await URLSession.shared.data(for: request)
            }
        } else {
            (data, response) = try await URLSession.shared.data(for: request)
        }
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
    
    private func generateIdezetURLRequest(translation: String, book: String, chapter: Int) -> URLRequest? {
        var components = URLComponents(string: "https://szentiras.hu")
        let path = "/api/idezet/\(book)\(chapter)/\(translation)"
        components?.path = path
        if let url = components?.url {
            return URLRequest(url: url)
        }
        return nil
    }
}
