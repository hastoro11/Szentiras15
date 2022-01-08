//
//  Extensions.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 30..
//

import SwiftUI

struct IconButtonStyle: ViewModifier {
    enum Size {
        case small, normal
    }
    var active: Bool
    var size: Size = .normal
    func body(content: Content) -> some View {
        content
            .font(.Theme.bold(size: 15))
            .foregroundColor(Color.white)
            .frame(width: size == .small ? 44 : 50, height: 44)
            .background(active ? Color.accentColor : Color.light)
    }
}

extension View {
    func iconButtonStyle(active: Bool, size: IconButtonStyle.Size = .normal) -> some View {
        self.modifier(IconButtonStyle(active: active, size: size))
    }
}

struct ViewModifiers_Preview: PreviewProvider {
    static var previews: some View {
        HStack {
            Text("1Móz")
                .iconButtonStyle(active: false)
                .padding()
            
            Text("1Móz")
                .iconButtonStyle(active: true)
                .padding()
            
            Text("12")
                .iconButtonStyle(active: false, size: .small)
                .padding()
            
            Text("119")
                .iconButtonStyle(active: true, size: .small)
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
