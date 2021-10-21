//
//  Font+Extension.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 21..
//

import SwiftUI

extension Font {
    static func book(size: CGFloat) -> Font {
        .custom("Avenir Book", size: size)
    }
    
    static func light(size: CGFloat) -> Font {
        .custom("Avenir Light", size: size)
    }
    
    static func medium(size: CGFloat) -> Font {
        .custom("Avenir Medium", size: size)
    }
    
    static func heavy(size: CGFloat) -> Font {
        .custom("Avenir Heavy", size: size)
    }
    
    static func black(size: CGFloat) -> Font {
        .custom("Avenir Black", size: size)
    }
}
