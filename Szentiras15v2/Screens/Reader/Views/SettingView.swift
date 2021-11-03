//
//  SettingView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 03..
//

import SwiftUI

struct SettingView: View {
    @Binding var fontSize: Double
    var body: some View {
        VStack(alignment: .leading) {
            Text("Betűméret".uppercased())
                .font(.Theme.heavy(size: 17))
                .frame(maxWidth: .infinity, alignment: .leading)
            Slider(value: $fontSize, in: 15.0...21.0, step: 2) { _ in
                UserDefaults.standard.saveFontSize(fontSize: fontSize)
            }
        }
        .padding()
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(fontSize: .constant(17))
    }
}
