//
//  SplashScreen.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 13..
//

import SwiftUI

struct SplashScreen: View {
    @State var removeSplashScreen: Bool = false
    @State var startGlow: Bool = false
    
    var body: some View {
        if !removeSplashScreen {
            ZStack {
                Image("andrik-langfield")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay(
                        LinearGradient(colors: [.clear, .black], startPoint: UnitPoint(x: 0.5, y: 0.2), endPoint: UnitPoint(x: 0.5, y: 2.2))
                    )
                
                VStack {
                    Spacer()
                    Text("Szentírás")
                        .foregroundColor(.white)
                        .font(.custom("Zapfino", size: 56))
                        .frame(width: 300, height: 150)
                        .glow(opacity: startGlow ? 1 : 0)
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5)) {
                    startGlow = true
                }
                withAnimation(.easeInOut(duration: 1.5).delay(1.5)) {
                    startGlow = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                    withAnimation {
                        removeSplashScreen.toggle()
                    }
                }
            }
        }
        
    }
}

extension View {
    func glow(opacity: CGFloat) -> some View {
        self
            .shadow(
                color: .white.opacity(opacity),
                radius: 10)
            .shadow(
                color: .white.opacity(opacity),
                radius: 15)
            .shadow(
                color: .white.opacity(opacity),
                radius: 20)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
