//
//  CustomToggle.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 04..
//

import SwiftUI

struct CustomToggle: View {
    @Binding var state: Bool
    var action: (Bool) -> Void
    var body: some View {
        ZStack {
            Rectangle().fill(state ? Color.accentColor : Color(uiColor: .systemGray3))
                
            HStack {
                if state {
                    Spacer()
                }
                Rectangle().fill(Color.white)
                    .frame(width: 30, height: 30)
                if !state {
                    Spacer()
                }
            }
        }
        .overlay(Rectangle().stroke(state ? Color.accentColor : Color(uiColor: .systemGray3), lineWidth: 3))
        .frame(width: 60, height: 30)
        .onTapGesture {
            withAnimation {
                state.toggle()
            }
            action(state)
        }
        
    }
}

struct CustomToggle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomToggle(state: .constant(true), action: {_ in})
                .padding()
                .previewLayout(.sizeThatFits)
            CustomToggle(state: .constant(false), action: {_ in})
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
