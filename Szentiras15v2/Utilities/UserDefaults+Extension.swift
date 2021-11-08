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
    
    var getFontSize: Double {
        let size = self.double(forKey: "fontSize")
        if size == 0 {
            return 17
        }
        
        return size
    }
    
    func setFontSizeSaved(value: Bool) {
        self.set(value, forKey: "isFontSizeSaved")
    }
    
    var isFontSizeSaved: Bool {
        self.bool(forKey: "isFontSizeSaved")
    }
    
    var historyCapacity: Int {
        let capacity = UserDefaults.standard.integer(forKey: "historyCapacity")
        if capacity == 0 {
            return 2
        }
        
        return capacity
    }
}
