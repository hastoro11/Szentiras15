//
//  SettingsView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 04..
//

import SwiftUI

struct SettingsView: View {
    @State var saveFontsize: Bool = true
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Betűméret elmentése")
                        .font(.Theme.book(size: 17))
                    Spacer()
//                    CheckmarkButton(state: $saveFontsize)
                    CustomToggle(state: $saveFontsize)
                }
                .padding()
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Beállítások")
                        .font(.Theme.heavy(size: 17))
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()

//        BibleToggle(state: .constant(true))
//            .padding()
//            .previewLayout(.sizeThatFits)
//        BibleToggle(state: .constant(false))
//            .padding()
//            .previewLayout(.sizeThatFits)
    }
}
