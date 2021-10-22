//
//  Vers.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 21..
//

import Foundation

// MARK: - Vers
struct Vers: Codable, Identifiable {
    var id: Int {
        hely.gepi
    }
    private var apiSzoveg: String?
    private var apiJegyzetek: [Jegyzet]?
    private var apiHely: Hely?
    
    enum CodingKeys: String, CodingKey {
        case apiHely = "hely"
        case apiJegyzetek = "jegyzetek"
        case apiSzoveg = "szoveg"
    }
    
    var szoveg: String {
        apiSzoveg ?? ""
    }
    
    var jegyzetek: [Jegyzet] {
        apiJegyzetek ?? []
    }
    
    var hely: Hely {
        apiHely ?? Hely(apiGepi: 0, apiSzep: "")
    }
    
    var versSzam: String {
        let hivatkozas = hely.szep
        return hivatkozas.split(separator: ",")[1].trimmingCharacters(in: .whitespaces) 
    }
}

// MARK: - Hely
struct Hely: Codable {
    var apiGepi: Int?
    var apiSzep: String?
    
    enum CodingKeys: String, CodingKey {
        case apiGepi = "gepi"
        case apiSzep = "szep"
    }
    
    var gepi: Int {
        apiGepi ?? 0
    }
    
    var szep: String {
        apiSzep ?? ""
    }
}

// MARK: - Jegyzetek
struct Jegyzet: Codable {
    var apiText: String?
    
    enum CodingKeys: String, CodingKey {
        case apiText = "text"
    }
    
    var text: String {
        apiText ?? ""
    }
}
