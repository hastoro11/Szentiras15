//
//  Util.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 21..
//

import Foundation

class Util {
    static let shared = Util()
    private init() {}
    
    static func getItemFromBundle<T: Codable>(filename: String) -> T {
        let url = Bundle.main.url(forResource: filename, withExtension: "json")!
        do {
            let data = try Data(contentsOf: url)
            let item = try JSONDecoder().decode(T.self, from: data)
            return item
        } catch {
            print("⛔️ Error in util", error)
            fatalError("Can't find '\(filename).json'")
        }
    }
}
