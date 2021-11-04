//
//  CustomToggle.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 04..
//

import SwiftUI

struct CustomToggle: View {
    @Binding var state: Bool
    var body: some View {
        ZStack {
            Rectangle().fill(state ? Color.accentColor : Color.Theme.background)
                
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
        .overlay(Rectangle().stroke(state ? Color.accentColor : Color.Theme.background, lineWidth: 3))
        .frame(width: 60, height: 30)
        .onTapGesture {
            withAnimation {
                state.toggle()
            }
        }
        
    }
}

struct CustomToggle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomToggle(state: .constant(true))
                .padding()
                .previewLayout(.sizeThatFits)
            CustomToggle(state: .constant(false))
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
