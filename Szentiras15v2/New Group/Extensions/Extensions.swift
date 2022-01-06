//
//  Extensions.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2022. 01. 06..
//

import Foundation

extension String {
    var htmlString: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
