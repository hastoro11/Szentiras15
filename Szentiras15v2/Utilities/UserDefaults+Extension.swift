//
//  UserDefaults+Extension.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 03..
//

import Foundation

extension UserDefaults {
    func saveFontSize(fontSize: Double) {
        self.set(fontSize, forKey: "fontSize")
    }
    
    func getFontSize() -> Double {
        let size = self.double(forKey: "fontSize")
        if size == 0 {
            return 17
        }
        
        return size
    }
}
