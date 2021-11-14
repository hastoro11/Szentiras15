//
//  SplashScreen.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 13..
//

import SwiftUI

struct SplashScreen: View {
    @State var removeSplashScreen: Bool = false
    @State var startAnimation: Bool = false
    @State var color: Color = .accentColor
    var body: some View {
        if !removeSplashScreen {
            ZStack {
                Color("Title")
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Image("bible")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                        .shadow(color: Color.white.opacity(startAnimation ? 1 : 0), radius: 30)
                        .foregroundColor(.white)
                        .colorMultiply(color)
                        
                        
                        
                    Spacer()
                    Spacer()
                    Spacer()
                    Text("Szentírás")
                        .foregroundColor(.white)
                        .font(.Theme.bold(size: 48))
                    Spacer()
                }
                
                    
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5)) {
                    color = .white
                    startAnimation = true
                }
                withAnimation(.easeInOut(duration: 1.5).delay(1.5)) {
                    color = .accentColor
                    startAnimation = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+4) {
                    withAnimation {
                        removeSplashScreen.toggle()
                    }
                }
            }
        }
        
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
