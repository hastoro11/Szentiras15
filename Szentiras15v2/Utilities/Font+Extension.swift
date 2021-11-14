//
//  Font+Extension.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 21..
//

import SwiftUI

extension Font {
    struct Theme {
        static func regular(size: CGFloat) -> Font {
            .custom("Fira Sans Regular", size: size)
        }
        
        static func light(size: CGFloat) -> Font {
            .custom("Fira Sans Light", size: size)
        }
        
        static func medium(size: CGFloat) -> Font {
            .custom("Fira Sans Medium", size: size)
        }
        
        static func bold(size: CGFloat) -> Font {
            .custom("Fira Sans Bold", size: size)
        }
    }    
}
